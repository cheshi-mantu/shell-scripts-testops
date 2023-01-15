DELETE_DELAY=48

ALLURE_TOKEN=$(cat ../secrets/token.txt)
ALLURE_ENDPOINT=$(cat ../secrets/endpoint.txt)

TARGET_ARTEFACT="attachment scenario fixture"
TEST_STATUS="passed failed broken unknown skipped"



for ARTEFACT in $TARGET_ARTEFACT
    do
        for STATUS in $TEST_STATUS
        do 
            echo "Marking ${ARTEFACT} for ${STATUS} tests for deletion after ${DELETE_DELAY} after creation \n"
            curl -X POST "${ALLURE_ENDPOINT}/api/rs/cleanerschema" --header "accept: */*" --header "Content-Type: application/json" --header "Authorization: Api-Token ${ALLURE_TOKEN}" -d "{\"status\": \"${STATUS}\",\"target\": \"${ARTEFACT}\",\"delay\": ${DELETE_DELAY}}"
            echo "\n"
        done
    done


# this will trigger the creation of the blob remove tasks immediately
# curl -X POST "${ALLURE_ENDPOINT}/api/rs/cleanup/scheduler/cleaner_schema_global" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}" -d ''