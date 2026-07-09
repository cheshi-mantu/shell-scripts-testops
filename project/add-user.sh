#!/usr/bin/env bash
set -euo pipefail

# Adds the same user as a collaborator to all projects of the instance.
#
# Usage: $0 <username> [permissionSetId]
#   permissionSetId defaults to -3 (Project Write)

ALLURE_TOKEN=$(cat ../secrets/token.txt)
ALLURE_ENDPOINT=$(cat ../secrets/endpoint.txt)

TARGET_USER=${1:-}
PERMISSION_SET_ID=${2:--3}
PAGE_SIZE=2000

if [ -z "${TARGET_USER}" ]; then
    echo "Usage: $0 <username> [permissionSetId]"
    exit 1
fi

JWT_TOKEN=$(../auth-bearer/get-bearer-token.sh "${ALLURE_ENDPOINT}" "${ALLURE_TOKEN}")

if [ -z "${JWT_TOKEN}" ] || [ "${JWT_TOKEN}" = "null" ]; then
    echo "ERROR: failed to obtain Bearer token"
    exit 1
fi

# get projects
PROJECTS=""
COUNT_PAGE=0
LAST_PAGE=false

while ! ${LAST_PAGE}; do
    echo "Getting page ${COUNT_PAGE}"
    RESPONSE=$(curl -sS -X GET "${ALLURE_ENDPOINT}/api/rs/project?page=${COUNT_PAGE}&size=${PAGE_SIZE}&sort=id%2CASC" \
        --header "accept: application/json" \
        --header "Authorization: Bearer ${JWT_TOKEN}")
    PROJECTS="${PROJECTS} $(jq -r '.content[].id' <<< "${RESPONSE}")"
    LAST_PAGE=$(jq -r '.last' <<< "${RESPONSE}")
    COUNT_PAGE=$((COUNT_PAGE + 1))
done

echo "Projects found: $(wc -w <<< "${PROJECTS}")"

for PROJECT in ${PROJECTS}; do
    echo "Adding ${TARGET_USER} (permissionSetId=${PERMISSION_SET_ID}) to project ${PROJECT}"
    curl -sS -X POST "${ALLURE_ENDPOINT}/api/project/access/${PROJECT}/collaborator" \
        --header "accept: application/json" \
        --header "content-type: application/json" \
        --header "Authorization: Bearer ${JWT_TOKEN}" \
        -d "{\"collaborators\":[{\"username\":\"${TARGET_USER}\",\"permissionSetId\":${PERMISSION_SET_ID}}]}"
    echo ""
done
