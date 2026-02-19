ALLURE_TOKEN=$(security find-generic-password -a "$USER" -s "TESTING_ALLURE_TOKEN" -w)
ALLURE_ENDPOINT=$(security find-generic-password -a "$USER" -s "TESTING_ALLURE_ENDPOINT" -w)
TODAY_DATE=$(date +%Y-%m-%d)

TESTOPS_DASHBOARD_ID=158
TESTOPS_WIDGET_ID=1658

if [[ "$OSTYPE" == "darwin"* ]]; then
    DAY_START_STAMP=$(($(date -j -f "%Y-%m-%d %H:%M:%S" "$(date +%Y-%m-%d) 00:00:00" +%s) * 1000))
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    DAY_START_STAMP=$(($(date -d "today 00:00:00" +%s) * 1000))
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

echo $DAY_START_STAMP

BEARER_TOKEN=$(../get-bearer-token.sh "${ALLURE_ENDPOINT}" "${ALLURE_TOKEN}")

# echo "Bearer: ${BEARER_TOKEN}"


curl -X PATCH https://testing.testops.cloud/api/widget/${TESTOPS_WIDGET_ID} \
  -H "accept: application/json" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${BEARER_TOKEN}" \
  --data-raw "{\"dashboardId\":${TESTOPS_DASHBOARD_ID},\"type\":\"launch_list\",\"name\":\"Regular Launches ${TODAY_DATE}\",\"options\":{\"type\":\"launch_list\",\"launchRql\":\"(tag in [\\\"regular\\\", \\\"regress\\\"]) and (createdDate > ${DAY_START_STAMP})\",\"datePickerEnabled\":false}}"
