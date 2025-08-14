if [ -z $1 ]; then
	echo "Usage: $0 <project_id>"
	exit 1
else 

ALLURE_TOKEN=$(cat ../../secrets/xyz-token.txt)
ALLURE_ENDPOINT=$(cat ../../secrets/xyz-endpoint.txt)
pageSize=2000
countPage=0
lastPage=false
PROJECT_ID=$1
PROJECT_TAGS_LIST=$1-all-tags.txt

JWT_TOKEN=$(curl -s -X POST "${ALLURE_ENDPOINT}/api/uaa/oauth/token" \
     --header "Expect:" \
     --header "Accept: application/json" \
     --form "grant_type=apitoken" \
     --form "scope=openid" \
     --form "token=${ALLURE_TOKEN}" \
     | jq -r .access_token)

echo "JWT token: ${JWT_TOKEN}"

while ! ${lastPage}; do
    echo "Getting page ${countPage}"
    RESPONSE=$(curl -X GET "${ALLURE_ENDPOINT}/api/tag/suggest?query=testrail%3A&projectId=${PROJECT_ID}&page=${countPage}&size=${pageSize}&sort=id%2CASC" --header "accept: */*" --header "Authorization: Bearer ${JWT_TOKEN}")
    if [ ${countPage} = 0 ]; then
        TAGS="$(jq .content[].id <<< $RESPONSE)"
    else
        TAGS="${TAGS}\n$(jq .content[].id <<< $RESPONSE)"
    fi
    totalElements=$(jq .totalElements <<< $RESPONSE)
    lastPage=$(jq .last <<< $RESPONSE)
    echo "Page: ${countPage}"
    echo "Last page? - ${lastPage}"
    countPage=$((countPage + 1))
done

echo "Dumping the list of projects to file ${PROJECT_TAGS_LIST}"
cat <<EOF > ${PROJECT_TAGS_LIST}
${TAGS}
EOF
fi

## that was just a dirty move to get rid of the empty strings

echo "Reading the list of projects from file ${PROJECT_TAGS_LIST}"
TAGS=$(<${PROJECT_TAGS_LIST})

echo "Tags: ${TAGS}"

for TAG in ${TAGS}; do
	echo "Deleting tag ${TAG}"
curl -X DELETE ${ALLURE_ENDPOINT}/api/tag/${TAG} -H 'accept: */*' --header "Authorization: Bearer ${JWT_TOKEN}" 1> /dev/null
done