ALLURE_TOKEN=$(cat ../secrets/token.txt)
ALLURE_ENDPOINT=$(cat ../secrets/endpoint.txt)
ALLURE_PROJECT_ID=2
PAGE_SIZE=1000

clear

RESULT=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/export?projectId=${ALLURE_PROJECT_ID}&page=0&size=${PAGE_SIZE}" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}")

echo ${RESULT}

echo "Found deleted test cases in the project ${ALLURE_PROJECT_ID}": 

IDS=$(echo $RESULT | jq .content[].id)

echo ${IDS}


for ID in ${IDS}
do
    echo "Purging export ${ID} \n"
    curl -X DELETE "${ALLURE_ENDPOINT}/api/rs/export/${ID}" --header "accept: */*" --header "Content-Type: application/json" --header "Authorization: Api-Token ${ALLURE_TOKEN}"
done


