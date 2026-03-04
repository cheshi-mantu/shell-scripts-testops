TESTOPS_TOKEN=$(cat ../secrets/token.txt)
TESTOPS_ENDPOINT=$(cat ../secrets/endpoint.txt)
TESTOPS_PROJECT_ID=10

BEARER_TOKEN=$(../auth-bearer/get-bearer-token.sh ${TESTOPS_ENDPOINT} ${TESTOPS_TOKEN})

TARGET_ARTEFACT="attachment scenario fixture"
TEST_STATUS="passed failed broken unknown skipped"

DELETE_DELAY=48

for ARTEFACT in $TARGET_ARTEFACT
    do
        for STATUS in $TEST_STATUS
        do 
            echo "Marking ${ARTEFACT} for ${STATUS} tests for deletion after ${DELETE_DELAY} after creation \n"
            curl -X POST "${TESTOPS_ENDPOINT}/api/rs/cleanerschema" --header "accept: */*" --header "Content-Type: application/json" -H "Authorization: Bearer ${BEARER_TOKEN}" -d "{\"projectId\": ${TESTOPS_PROJECT_ID},\"status\": \"${STATUS}\",\"target\": \"${ARTEFACT}\",\"delay\": ${DELETE_DELAY}}"
            echo "\n"
        done
    done



