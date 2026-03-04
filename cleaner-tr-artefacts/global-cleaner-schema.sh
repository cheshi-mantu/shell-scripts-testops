DELETE_DELAY=96

TESTOPS_TOKEN=$(cat ../secrets/token.txt)
TESTOPS_ENDPOINT=$(cat ../secrets/endpoint.txt)
TESTOPS_PROJECT_ID=10

BEARER_TOKEN=$(../auth-bearer/get-bearer-token.sh ${TESTOPS_ENDPOINT} ${TESTOPS_TOKEN})

TARGET_ARTEFACT="attachment scenario fixture"
TEST_STATUS="passed failed broken unknown skipped"



for ARTEFACT in $TARGET_ARTEFACT
    do
        for STATUS in $TEST_STATUS
        do 
            echo "Marking ${ARTEFACT} for ${STATUS} tests for deletion after ${DELETE_DELAY} after creation \n"
            curl -X POST "${TESTOPS_ENDPOINT}/api/rs/cleanerschema" --header "accept: */*" --header "Content-Type: application/json" --header "Authorization: Bearer ${BEARER_TOKEN}" -d "{\"status\": \"${STATUS}\",\"target\": \"${ARTEFACT}\",\"delay\": ${DELETE_DELAY}}"
            echo "\n"
        done
    done


# this will trigger the creation of the blob remove tasks immediately
# curl -X POST "${TESTOPS_ENDPOINT}/api/rs/cleanup/scheduler/cleaner_schema_global" --header "accept: */*" --header "Authorization: Bearer ${BEARER_TOKEN}" -d ''