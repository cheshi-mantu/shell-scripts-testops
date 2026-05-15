LAUNCH_ID=$(allurectl job-run env | grep ALLURE_LAUNCH_ID | awk '{print $3}')
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
