ACTIVE=-3
OUTDATED=-4
OPERATION=$1
CI_BRANCH=$2

if [ $CI_BRANCH = "master" ] && [ $CI_PIPELINE_SOURCE != "api" ]; then
        # set all test cases in the project to Outdated    
        if [ $OPERATION = "before" ]; then
            echo "Setting all tests in project ${ALLURE_PROJECT_ID} to outdated"
            PROJECT_TESTS=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/testcase?projectId=${ALLURE_PROJECT_ID}&page=0&size=10000" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}" | yq -P .content[].id) > /dev/null
            for ID in ${PROJECT_TESTS}
                do
                    #echo "Setting ${ID} to OUTDATED"
                    # curl -X PATCH ${ALLURE_ENDPOINT}/api/rs/testcase/${ID} --header "accept: */*" --header "Content-Type: application/json" --header "Authorization: Api-Token ${ALLURE_TOKEN}" -d "{\"statusId\": $OUTDATED}" > /dev/null
                    curl -X PATCH ${ALLURE_ENDPOINT}/api/rs/testcase/${ID} --header "accept: */*" --header "Content-Type: application/json" --header "Authorization: Api-Token ${ALLURE_TOKEN}" -d "{\"statusId\": $OUTDATED}" & > /dev/null
                done
        # restore found test cases from the launch to Active state
        elif [ $OPERATION = "after" ]; then
            export $(./allurectl job-run env)
            echo "Setting test cases from this run to active"
            RESULT=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/testresult?launchId=${ALLURE_LAUNCH_ID}&page=0&size=10000" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}") > /dev/null
            echo "${RESULT}" | yq -P '.totalPages'
            PAGES_TOTAL=$(echo "${RESULT}" | yq -P '.totalPages')
            echo "Total pages=${PAGES_TOTAL}"
            LAUNCH_IDS=$(echo $RESULT | yq -P '.content[].testCaseId')
            echo ${LAUNCH_IDS}
            for ID in ${LAUNCH_IDS} 
                do
                    #echo "Setting ${ID} to ACTIVE"
                    curl -X PATCH ${ALLURE_ENDPOINT}/api/rs/testcase/${ID} --header "accept: */*" --header "Content-Type: application/json" --header "Authorization: Api-Token ${ALLURE_TOKEN}" -d "{\"statusId\": $ACTIVE}"  > /dev/null
                done
        else
            echo "Unknown routine. Just exiting. See ya."
        fi
else
    echo "Starting requirements aren't met, exiting with no actions"
fi 
