ALLURE_ENDPOINT=${ALLURE_ENDPOINT}
ALLURE_TOKEN=${ALLURE_TOKEN}

LAUNCH_ID=238979


ISSUES="[{"integrationId":2,"name":"AE-5"}]"

curl -X PATCH "${ALLURE_ENDPOINT}/api/rs/launch/${LAUNCH_ID}" --header "accept: */*" --header "Content-Type: application/json" --header "Authorization: Api-Token ${ALLURE_TOKEN}" --data "{\"issues\":${ISSUES}}"



