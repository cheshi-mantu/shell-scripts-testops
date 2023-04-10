ALLURE_TOKEN=$(cat ../../secrets/testing_token.txt)
ALLURE_ENDPOINT=$(cat ../../secrets/testing_endpoint.txt)
TARGET_ARTEFACT="attachment scenario fixture"
TEST_STATUS="passed failed broken unknown skipped"
DELETE_DELAY=48


ALL_PROJECTS=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/project?page=0&size=10000" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}"  | jq .content[].id)

echo "${ALL_PROJECTS}"

for ALLURE_PROJECT_ID in ${ALL_PROJECTS}

do 
    echo "Working with project ${ALLURE_PROJECT_ID}"

    for ARTEFACT in $TARGET_ARTEFACT
        do
            for STATUS in $TEST_STATUS
            do 
                echo "Marking ${ARTEFACT} for ${STATUS} tests for deletion after ${DELETE_DELAY} after creation \n"
                curl -X POST "${ALLURE_ENDPOINT}/api/rs/cleanerschema" --header "accept: */*" --header "Content-Type: application/json" --header "Authorization: Api-Token ${ALLURE_TOKEN}" -d "{\"projectId\": ${ALLURE_PROJECT_ID},\"status\": \"${STATUS}\",\"target\": \"${ARTEFACT}\",\"delay\": ${DELETE_DELAY}}"
                echo "\n"
            done
        done

done

