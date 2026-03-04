ALLURE_TOKEN=$(cat ../../secrets/testing_token.txt)
ALLURE_ENDPOINT=$(cat ../../secrets/testing_endpoint.txt)

# this will trigger the creation of the blob remove tasks immediately
curl -X POST "${ALLURE_ENDPOINT}/api/rs/cleanup/scheduler/cleaner_schema_global" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}" -d ''