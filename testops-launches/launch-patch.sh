# this is for gitlab only at the moment
# launch data need to be set via ENV variables for this script to work

if [ ${CI_PIPELINE_SOURCE} = "api" ]; then

ALLURE_TAGS=${ALLURE_LAUNCH_TAGS}
LAUNCH_NAME="${ALLURE_LAUNCH_NAME} by ${ALLURE_USERNAME}"
ALLURE_TOKEN=${ALLURE_TOKEN}
LAUNCH_ID=${ALLURE_LAUNCH_ID}
ALLURE_ENDPOINT=${ALLURE_ENDPOINT}

ALLURE_TAGS=$(echo "$ALLURE_TAGS" | sed -e 's/, / /g')

JSON_TAGS=""
for tag in $ALLURE_TAGS; do
    JSON_TAGS="$JSON_TAGS {\"name\":\"$tag\"},"
done

#remove tailing comma
JSON_TAGS=$(echo "${JSON_TAGS}" | sed 's/,*$//')
# remove all spaces
JSON_TAGS=$(echo "$JSON_TAGS" | sed -e 's/ //g')
echo "tags: ${JSON_TAGS}"

curl -X PATCH "${ALLURE_ENDPOINT}/api/rs/launch/${LAUNCH_ID}" --header "accept: */*" --header "Content-Type: application/json" --header "Authorization: Api-Token ${ALLURE_TOKEN}" --data "{\"name\": \"${LAUNCH_NAME}\",\"tags\":[${JSON_TAGS}]}"
fi
