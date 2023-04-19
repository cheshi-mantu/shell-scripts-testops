ALLURE_TOKEN=$(cat ../../secrets/testing_token.txt)
ALLURE_ENDPOINT=$(cat ../../secrets/testing_endpoint.txt)


ALL_PROJECTS=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/project?page=0&size=10000&sort=id%2CASC" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}"  | jq .content[].id)

for ALLURE_PROJECT_ID in ${ALL_PROJECTS}

do 
    echo "\nProject ${ALLURE_PROJECT_ID}" | tee -a projects-cleanup-existing.txt
    curl -X GET "${ALLURE_ENDPOINT}/api/rs/cleanerschema?projectId=${ALLURE_PROJECT_ID}&page=0&size=1000&sort=id%2CASC" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}" | tee -a projects-cleanup-existing.txt
done

