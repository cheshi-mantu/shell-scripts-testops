ALLURE_TOKEN=<token>
ALLURE_ENDPOINT=https://<testops>
ALLURE_PROJECT_ID=<PROJECT_ID>
RESTORE_TEST_CASES_PER_RUN=100

clear

RESULT=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/testcase/deleted?projectId=${ALLURE_PROJECT_ID}&page=0&size=${RESTORE_TEST_CASES_PER_RUN}" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}")

echo "Found deleted test cases in the project ${ALLURE_PROJECT_ID}": 

IDS=$(echo $RESULT | jq .content[].id)

echo ${IDS}


for ID in ${IDS}
do
    echo "Restoring ${ID} \n"
    curl -X PATCH ${ALLURE_ENDPOINT}/api/rs/testcase/${ID} --header "accept: */*" --header "Content-Type: application/json" --header "Authorization: Api-Token ${ALLURE_TOKEN}" -d "{\"deleted\": false}"
    echo "\n"
done