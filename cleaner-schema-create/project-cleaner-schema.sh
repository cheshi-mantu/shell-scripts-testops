ALLURE_TOKEN=$(cat ../secrets/token.txt)
ALLURE_ENDPOINT=$(cat ../secrets/endpoint.txt)
ALLURE_PROJECT_ID=10

TARGET_ARTEFACT="attachment scenario fixture"
TEST_STATUS="passed failed broken unknown skipped"

DELETE_DELAY=48

for ARTEFACT in $TARGET_ARTEFACT
    do
        for STATUS in $TEST_STATUS
        do 
            echo "Marking ${ARTEFACT} for ${STATUS} tests for deletion after ${DELETE_DELAY} after creation \n"
            curl -X POST "${ALLURE_ENDPOINT}/api/rs/cleanerschema" --header "accept: */*" --header "Content-Type: application/json" --header "Authorization: Api-Token ${ALLURE_TOKEN}" -d "{\"projectId\": ${ALLURE_PROJECT_ID},\"status\": \"${STATUS}\",\"target\": \"${ARTEFACT}\",\"delay\": ${DELETE_DELAY}}"
            echo "\n"
        done
    done



