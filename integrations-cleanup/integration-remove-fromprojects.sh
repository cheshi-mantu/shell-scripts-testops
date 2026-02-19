ALLURE_TOKEN=$(cat ../../secrets/testing_token.txt)
ALLURE_ENDPOINT=$(cat ../../secrets/testing_endpoint.txt)
ALLURE_INTEGRATION_ID=11


RESULT=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/integration/${ALLURE_INTEGRATION_ID}/project?page=0&size=10000" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}" | jq '.content[].id')


for ID in ${RESULT} 
    do
        echo "Attempt to delete the integration ${ALLURE_INTEGRATION_ID} from the project ${ID}"
        curl -X DELETE "${ALLURE_ENDPOINT}/api/rs/integration/${ALLURE_INTEGRATION_ID}/project/${ID}" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}"
    done

# danger zone
# this will also delete the integration completely from the global settings
# curl -X DELETE "${ALLURE_ENDPOINT}/api/rs/integration/${ALLURE_INTEGRATION_ID}" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}"

