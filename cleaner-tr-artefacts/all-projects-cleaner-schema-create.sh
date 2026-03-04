TESTOPS_TOKEN=$(cat ../secrets/token.txt)
TESTOPS_ENDPOINT=$(cat ../secrets/endpoint.txt)

BEARER_TOKEN=$(../auth-bearer/get-bearer-token.sh ${TESTOPS_ENDPOINT} ${TESTOPS_TOKEN})



TARGET_ARTEFACT="attachment scenario fixture"
TEST_STATUS="passed failed broken unknown skipped"
DELETE_DELAY=48


ALL_PROJECTS=$(curl -X GET "${TESTOPS_ENDPOINT}/api/rs/project?page=0&size=10000" --header "accept: */*" --header "Authorization: Bearer ${BEARER_TOKEN}"  | jq .content[].id)

echo "${ALL_PROJECTS}"

for TESTOPS_PROJECT_ID in ${ALL_PROJECTS}

do 
    echo "Working with project ${TESTOPS_PROJECT_ID}"

    for ARTEFACT in $TARGET_ARTEFACT
        do
            for STATUS in $TEST_STATUS
            do 
                echo "Marking ${ARTEFACT} for ${STATUS} tests for deletion after ${DELETE_DELAY} after creation \n"
                curl -X POST "${TESTOPS_ENDPOINT}/api/rs/cleanerschema" --header "accept: */*" --header "Content-Type: application/json" --header "Authorization: Bearer ${BEARER_TOKEN}" -d "{\"projectId\": ${TESTOPS_PROJECT_ID},\"status\": \"${STATUS}\",\"target\": \"${ARTEFACT}\",\"delay\": ${DELETE_DELAY}}"
                echo "\n"
            done
        done

done

