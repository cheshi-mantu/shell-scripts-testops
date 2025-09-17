ALLURE_INTEGRATION_ID=$1

./get-integration-projects.sh ${ALLURE_INTEGRATION_ID} && ./integration-projects-remove.sh ${ALLURE_INTEGRATION_ID} && ./delete-integration.sh ${ALLURE_INTEGRATION_ID}