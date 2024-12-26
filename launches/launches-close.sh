ALLURE_TOKEN=$(cat ../secrets/xyz-token.txt)
ALLURE_ENDPOINT=$(cat ../secrets/xyz-endpoint.txt)
pageSize=2000
countPage=0
lastPage=false
FILE_PROJECTS_LIST=all-projects.txt
FILE_PROJECTS_CLOSE=all-projects-close-rules.txt

rm ${FILE_PROJECTS_LIST}
rm ${FILE_PROJECTS_CLOSE}

JWT_TOKEN=$(curl -s -X POST "${ALLURE_ENDPOINT}/api/uaa/oauth/token" \
     --header "Expect:" \
     --header "Accept: application/json" \
     --form "grant_type=apitoken" \
     --form "scope=openid" \
     --form "token=${ALLURE_TOKEN}" \
     | jq -r .access_token)


while ! ${lastPage}; do
    echo "Getting page ${countPage}"
    RESPONSE=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/project?page=${countPage}&size=${pageSize}&sort=id%2CASC" --header "accept: */*" --header "Authorization: Bearer ${JWT_TOKEN}")
    if [ ${countPage} = 0 ]; then
        PROJECTS="$(jq .content[].id <<< $RESPONSE)"
    else
        PROJECTS="${PROJECTS}\n$(jq .content[].id <<< $RESPONSE)"
    fi
    totalElements=$(jq .totalElements <<< $RESPONSE)
    lastPage=$(jq .last <<< $RESPONSE)
    echo "Page: ${countPage}"
    echo "Last page? - ${lastPage}"
    countPage=$((countPage + 1))
done

# save projects
echo "Dumping the list of projects to file ${FILE_PROJECTS_LIST}"
cat <<EOF > ${FILE_PROJECTS_LIST}
${PROJECTS}
EOF

echo "Reading the list of projects from file ${FILE_PROJECTS_LIST}"
PROJECTS=$(<${FILE_PROJECTS_LIST})

for PROJECT in ${PROJECTS}; do
    echo "${PROJECT}"
    # OPEN_LAUNCHES=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/launch/__search?projectId=${PROJECT}&rql=closed%20%3D%20false&page=0&size=2000&sort=id%2CDESC'" --header "accept: */*" --header "Authorization: Bearer ${JWT_TOKEN}" | yq e '.content[].id')
    OPEN_LAUNCHES=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/launch/__search?projectId=${PROJECT}&rql=closed%20%3D%20false&page=0&size=2000&sort=id%2CDESC" --header "accept: */*" --header "Authorization: Bearer ${JWT_TOKEN}" | yq e '.content[].id' -o=json | tr -d '[],' | tr '\n' ' ')
    FILE_DUMP="${FILE_DUMP}\n${OPEN_LAUNCHES}"
done

# Clean up the FILE_DUMP string
FILE_DUMP=$(echo -e "$FILE_DUMP" | tr -s ' ' | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')

echo "!!! ${FILE_DUMP} !!!"


echo "launches in open state: ${FILE_DUMP}"