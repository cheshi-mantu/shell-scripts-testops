TESTOPS_TOKEN=$(cat ../secrets/token.txt)
TESTOPS_ENDPOINT=$(cat ../secrets/endpoint.txt)
TESTOPS_PROJECT_ID=10

BEARER_TOKEN=$(../auth-bearer/get-bearer-token.sh ${TESTOPS_ENDPOINT} ${TESTOPS_TOKEN})

# this will trigger the creation of the blob remove tasks immediately
curl -X POST "${TESTOPS_ENDPOINT}/api/rs/cleanup/scheduler/cleaner_schema_global" --header "accept: */*" --header "Authorization: Bearer ${BEARER_TOKEN}" -d ''