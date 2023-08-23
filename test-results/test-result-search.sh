#fill these

ALLURE_PROJECT_ID=<PROJECT_ID>
LAUNCH_ID=<LAUNCH_ID>
ALLURE_TOKEN=$(cat ../../secrets/testing_token.txt)
ALLURE_ENDPOINT=$(cat ../../secrets/testing_endpoint.txt)


# do not change here
RQL="launch="${LAUNCH_ID}

clear
echo "${RQL}"
curl -X GET "${ALLURE_ENDPOINT}/api/rs/testresult/__search?projectId=${ALLURE_PROJECT_ID}&rql=${RQL}&page=0&size=2000" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}" test_results_launch_${LAUNCH_ID}.txt