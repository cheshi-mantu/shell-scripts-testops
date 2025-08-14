ALLURE_TOKEN=$(cat ../../secrets/xyz-token.txt)
ALLURE_ENDPOINT=$(cat ../../secrets/xyz-endpoint.txt)
pageSize=1999
countPage=0
lastPage=false
FILE_PROJECTS_LIST=all-projects.txt

rm ${FILE_PROJECTS_LIST}

JWT_TOKEN=$(curl -s -X POST "${ALLURE_ENDPOINT}/api/uaa/oauth/token" \
     --header "Expect:" \
     --header "Accept: application/json" \
     --form "grant_type=apitoken" \
     --form "scope=openid" \
     --form "token=${ALLURE_TOKEN}" \
     | jq -r .access_token)

# echo "JWT token: ${JWT_TOKEN}"

while ! ${lastPage}; do
    echo "Getting page ${countPage}"
    RESPONSE=$(curl -X GET "${ALLURE_ENDPOINT}/api/project?page=${countPage}&size=${pageSize}&sort=id%2CASC" --header "accept: */*" --header "Authorization: Bearer ${JWT_TOKEN}")
    if [ ${countPage} = 0 ]; then
        PROJECTS="$(jq .content[].id <<< $RESPONSE)"
		echo "Projects: ${PROJECTS}"
    else
        PROJECTS="${PROJECTS}\n$(jq .content[].id <<< $RESPONSE)"
    fi
    totalElements=$(jq .totalElements <<< $RESPONSE)
    lastPage=$(jq .last <<< $RESPONSE)
    echo "Page: ${countPage}"
    echo "Last page? - ${lastPage}"
    countPage=$((countPage + 1))
done

echo "Dumping the list of projects to file ${FILE_PROJECTS_LIST}"
cat <<EOF > ${FILE_PROJECTS_LIST}
${PROJECTS}
EOF
