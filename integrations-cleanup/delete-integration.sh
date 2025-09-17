ALLURE_TOKEN=$(cat ../secrets/token.txt)
ALLURE_ENDPOINT=$(cat ../secrets/endpoint.txt)
ALLURE_INTEGRATION_ID=$1


echo "Deleting integration ${ALLURE_INTEGRATION_ID}"

curl -X DELETE "${ALLURE_ENDPOINT}/api/rs/integration/${ALLURE_INTEGRATION_ID}" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}"