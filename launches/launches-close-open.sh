#!/usr/bin/env bash
# Closes every launch that is currently in open state for a given project.
# usage:
#   ./launches-close-open.sh <projectId>              close all open launches
#   ./launches-close-open.sh <projectId> --dry-run    list them without closing

set -euo pipefail
ALLURE_TOKEN=$(cat ../secrets/xyz-token.txt)
ALLURE_ENDPOINT=$(cat ../secrets/xyz-endpoint.txt)

PROJECT="${1:-}"
MODE="${2:-}"
DELAY="${DELAY:-0.2}"

if [[ -z "${PROJECT}" ]]; then
  echo "usage: $0 <projectId> [--dry-run]"
  exit 1
fi


JWT_TOKEN=$(curl -s -X POST "${ALLURE_ENDPOINT}/api/uaa/oauth/token" \
  --header "Expect:" \
  --header "Accept: application/json" \
  --form "grant_type=apitoken" \
  --form "scope=openid" \
  --form "token=${ALLURE_TOKEN}" \
  | jq -r .access_token)

if [[ -z "${JWT_TOKEN}" || "${JWT_TOKEN}" == "null" ]]; then
  echo "could not obtain a JWT token, check the API token and the endpoint"
  exit 1
fi

OPEN_LAUNCHES=$(curl -s -X GET \
  "${ALLURE_ENDPOINT}/api/rs/launch/__search?projectId=${PROJECT}&rql=closed%20%3D%20false&page=0&size=2000&sort=id%2CDESC" \
  --header "accept: */*" \
  --header "Authorization: Bearer ${JWT_TOKEN}" \
  | jq -r '.content[].id')

if [[ -z "${OPEN_LAUNCHES}" ]]; then
  echo "project ${PROJECT}: no launches in open state"
  exit 0
fi

TOTAL=$(echo "${OPEN_LAUNCHES}" | wc -w | tr -d ' ')
echo "project ${PROJECT}: ${TOTAL} launches in open state"

if [[ "${MODE}" == "--dry-run" ]]; then
  echo "${OPEN_LAUNCHES}" | tr '\n' ' '
  echo
  echo "dry run, nothing was closed"
  exit 0
fi

CLOSED=0
FAILED=0

for LAUNCH in ${OPEN_LAUNCHES}; do
  HTTP_CODE=$(curl -s -o /dev/null -w '%{http_code}' -X POST \
    "${ALLURE_ENDPOINT}/api/rs/launch/${LAUNCH}/close" \
    --header "accept: */*" \
    --header "Authorization: Bearer ${JWT_TOKEN}")

if [[ "${HTTP_CODE}" =~ ^2[0-9][0-9]$ ]]; then
    CLOSED=$((CLOSED + 1))
    echo "launch ${LAUNCH}: closed (http ${HTTP_CODE})"
  else
    FAILED=$((FAILED + 1))
    echo "launch ${LAUNCH}: failed with http ${HTTP_CODE}"
  fi

  sleep "${DELAY}"
done

echo "project ${PROJECT}: closed ${CLOSED}, failed ${FAILED}"