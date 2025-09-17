ALLURE_TOKEN=$(cat ../secrets/token.txt)
ALLURE_ENDPOINT=$(cat ../secrets/endpoint.txt)
ALLURE_INTEGRATION_ID=$1
FILE_PROJECTS_LIST=projects.txt

PROJECTS=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/integration/${ALLURE_INTEGRATION_ID}/project?page=0&size=10000" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}" | jq '.content[].id')


echo "Dumping the list of projects to file ${FILE_PROJECTS_LIST}"
cat <<EOF > ${FILE_PROJECTS_LIST}
${PROJECTS}
EOF




# for ID in ${RESULT} 
#     do
#         echo "Attempt to delete the integration ${ALLURE_INTEGRATION_ID} from the project ${ID}"
#         curl -X DELETE "${ALLURE_ENDPOINT}/api/rs/integration/${ALLURE_INTEGRATION_ID}/project/${ID}" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}"
#     done

