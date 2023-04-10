ALLURE_TOKEN=$(cat ../../secrets/testing_token.txt)
ALLURE_ENDPOINT=$(cat ../../secrets/testing_endpoint.txt)
# ALLURE_PROJECT_ID=<PROJECT_ID>

clear

echo "Removing all test keys data from all the test cases of the project ${ALLURE_PROJECT_ID}"


  'https://testing.allure.aws.qameta.in/api/rs/testcase?projectId=99&page=0&size=10&sort=createdDate%2CDESC' \
  -H 'accept: */*' 


TEST_CASES=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/testcase?projectId=${ALLURE_PROJECT_ID}&page=0&size=10000&sort=createdDate%2CDESC" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}")


IDS=$(echo $TEST_CASES | jq .content[].id)

echo "For the following IDs we'll delete all tesk keys info: ${IDS}"


for ID in ${IDS}
do
    curl -X POST ${ALLURE_ENDPOINT}/api/rs/testcase/${ID}/testkey --header "accept: */*" --header "Content-Type: application/json" --header "Authorization: Api-Token ${ALLURE_TOKEN}" -d "[]"
done
