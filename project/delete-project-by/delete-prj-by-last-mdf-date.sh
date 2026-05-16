#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname)" == "Darwin" ]]; then
    export TESTOPS_TOKEN=$(security find-generic-password -a "$USER" -s "TESTING_ALLURE_TOKEN" -w)
    export TESTOPS_ENDPOINT=$(security find-generic-password -a "$USER" -s "TESTING_ALLURE_ENDPOINT" -w)
else
    export TESTOPS_TOKEN=$(cat ../../secrets/token.txt)
    export TESTOPS_ENDPOINT=$(cat ../../secrets/endpoint.txt)
fi

# Delete projects not modified since this date (epoch milliseconds)
# Default: Fri Dec 31 2021 22:59:59 GMT+0000
BEFORE_DATE=${1:-1704063599000}
PAGE_SIZE=2000

BEARER_TOKEN=$(../../auth-bearer/get-bearer-token.sh ${TESTOPS_ENDPOINT} ${TESTOPS_TOKEN})

if [ -z "${BEARER_TOKEN}" ] || [ "${BEARER_TOKEN}" = "null" ]; then
    echo "ERROR: failed to obtain Bearer token"
    exit 1
fi

echo "Bearer token obtained successfully"

# Fetch all projects with pagination
ALL_PROJECTS="[]"
PAGE=0
LAST_PAGE=false

while [ "${LAST_PAGE}" = "false" ]; do
    echo "Fetching projects page ${PAGE}..."
    RESPONSE=$(curl -s -X GET \
        "${TESTOPS_ENDPOINT}/api/rs/project?page=${PAGE}&size=${PAGE_SIZE}&sort=id%2CASC" \
        --header "accept: application/json" \
        --header "Authorization: Bearer ${BEARER_TOKEN}")

    LAST_PAGE=$(echo "${RESPONSE}" | jq -r '.last')
    TOTAL=$(echo "${RESPONSE}" | jq -r '.totalElements')
    PAGE_CONTENT=$(echo "${RESPONSE}" | jq '.content')

    ALL_PROJECTS=$(echo "${ALL_PROJECTS}" "${PAGE_CONTENT}" | jq -s '.[0] + .[1]')

    echo "  Page ${PAGE}: got $(echo "${PAGE_CONTENT}" | jq 'length') projects (total: ${TOTAL}, last: ${LAST_PAGE})"
    PAGE=$((PAGE + 1))
done

echo ""
echo "Total projects fetched: $(echo "${ALL_PROJECTS}" | jq 'length')"

STALE_PROJECTS=$(echo "${ALL_PROJECTS}" | jq --argjson before "${BEFORE_DATE}" '[.[] | select(.lastModifiedDate < $before) | select(.name | test("Resident"; "i") | not)]')

STALE_COUNT=$(echo "${STALE_PROJECTS}" | jq 'length')
echo "Projects last modified before epoch ${BEFORE_DATE}: ${STALE_COUNT}"
echo ""
echo "${STALE_PROJECTS}" | jq -r '.[] | "\(.id)\t\(.lastModifiedDate)\t\(.createdBy)\t\(.name)"'
echo ""

if [ "${STALE_COUNT}" -eq 0 ]; then
    echo "Nothing to delete."
    exit 0
fi

read -p "Delete all ${STALE_COUNT} projects? [y/N] " CONFIRM
if [[ "${CONFIRM}" != "y" && "${CONFIRM}" != "Y" ]]; then
    echo "Aborted."
    exit 0
fi

echo ""
STALE_IDS=$(echo "${STALE_PROJECTS}" | jq -r '.[].id')
for PROJECT_ID in ${STALE_IDS}; do
    echo "Deleting project ${PROJECT_ID}..."
    curl -s -X DELETE \
        "${TESTOPS_ENDPOINT}/api/project/${PROJECT_ID}" \
        --header "accept: */*" \
        --header "Authorization: Bearer ${BEARER_TOKEN}"
    echo "  Done"
done

echo ""
echo "Deleted ${STALE_COUNT} projects not modified since epoch ${BEFORE_DATE}"
