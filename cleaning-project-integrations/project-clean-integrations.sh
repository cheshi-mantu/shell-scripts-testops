ALLURE_TOKEN=$(cat ../../secrets/token.txt)
ALLURE_ENDPOINT=$(cat ../../secrets/endpoint.txt)
ALLURE_PROJECT_ID=3

# curl -X GET "${ALLURE_ENDPOINT}/api/rs/integration/project/${ALLURE_PROJECT_ID}?page=0&size=1000&sort=name%2CASC" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}"

PROJECT_INTEGRATIONS=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/integration/project/${ALLURE_PROJECT_ID}?page=0&size=1000&sort=name%2CASC" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}" | yq -P .content[].id)



echo "${PROJECT_INTEGRATIONS}"

for INTEGRATION in $PROJECT_INTEGRATIONS
    do
        echo "We're about to delete integration # ${INTEGRATION}\n"
        curl -X DELETE "${ALLURE_ENDPOINT}/api/rs/integration/${INTEGRATION}/project/${ALLURE_PROJECT_ID}" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}"
    done



