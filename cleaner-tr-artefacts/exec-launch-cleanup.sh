TESTOPS_TOKEN=$(cat ../secrets/xyz-token.txt)
TESTOPS_ENDPOINT=$(cat ../secrets/xyz-endpoint.txt)
TESTOPS_LAUNCH_IDS="[8272]"
RESULTS_STATUSES='["passed", "failed", "broken", "unknown", "skipped"]'
BEARER_TOKEN=$(../auth-bearer/get-bearer-token.sh "${TESTOPS_ENDPOINT}" "${TESTOPS_TOKEN}")
ARTEFACTS_TARGETS='["fixture","attachment", "scenario"]'


# Trigger blob remove tasks immediately
curl -X POST "${TESTOPS_ENDPOINT}/api/rs/cleanup/scheduler/cleaner_schema_global" \
  -H "accept: */*" \
  -H "Authorization: Bearer ${BEARER_TOKEN}" \
  -d ''

# statuses
# "statuses": ["passed", "failed", "broken", "unknown", "skipped"],
# targets
# "targets": ["fixture","attachment", "scenario"]

curl -X 'POST' "${TESTOPS_ENDPOINT}/api/cleanup/launch" \
  -H 'accept: */*' \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer ${BEARER_TOKEN}" \
  -d "{
  \"launchIds\": ${TESTOPS_LAUNCH_IDS},
  \"statuses\": ${RESULTS_STATUSES},
  \"targets\": ${ARTEFACTS_TARGETS}
}"