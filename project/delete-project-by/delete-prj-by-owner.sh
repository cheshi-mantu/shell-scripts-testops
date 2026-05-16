#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname)" == "Darwin" ]]; then
    export TESTOPS_TOKEN=$(security find-generic-password -a "$USER" -s "TESTING_ALLURE_TOKEN" -w)
    export TESTOPS_ENDPOINT=$(security find-generic-password -a "$USER" -s "TESTING_ALLURE_ENDPOINT" -w)
else
    export TESTOPS_TOKEN=$(cat ../../secrets/token.txt)
    export TESTOPS_ENDPOINT=$(cat ../../secrets/endpoint.txt)
fi

# isernam is the default username which project we delete
TARGET_USER=${1:-username}
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

OWNED_PROJECTS=$(echo "${ALL_PROJECTS}" | jq --arg user "${TARGET_USER}" '[.[] | select(.createdBy == $user)]')

OWNED_COUNT=$(echo "${OWNED_PROJECTS}" | jq 'length')
echo "Projects created by '${TARGET_USER}': ${OWNED_COUNT}"
echo ""
echo "${OWNED_PROJECTS}" | jq -r '.[] | "\(.id)\t\(.name)"'
echo ""

if [ "${OWNED_COUNT}" -eq 0 ]; then
    echo "Nothing to delete."
    exit 0
fi

echo ""
OWNED_IDS=$(echo "${OWNED_PROJECTS}" | jq -r '.[].id')
for PROJECT_ID in ${OWNED_IDS}; do
    echo "Deleting project ${PROJECT_ID}..."
    curl -s -X DELETE \
        "${TESTOPS_ENDPOINT}/api/project/${PROJECT_ID}" \
        --header "accept: */*" \
        --header "Authorization: Bearer ${BEARER_TOKEN}"
    echo "  Done"
done

echo ""
echo "Deleted ${OWNED_COUNT} projects by '${TARGET_USER}'"
