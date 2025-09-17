ALLURE_TOKEN=$(cat ../secrets/token.txt)
ALLURE_ENDPOINT=$(cat ../secrets/endpoint.txt)
ALLURE_INTEGRATION_ID=$1
FILE_PROJECTS_LIST=projects.txt

PROJECTS=$(<${FILE_PROJECTS_LIST})


for ID in ${PROJECTS} 
    do
        echo "Attempt to delete the integration ${ALLURE_INTEGRATION_ID} from the project ${ID}"
        curl -X DELETE "${ALLURE_ENDPOINT}/api/rs/integration/${ALLURE_INTEGRATION_ID}/project/${ID}" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}"
    done

rm ${FILE_PROJECTS_LIST}