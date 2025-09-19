# this could be a very long process
# Variables
ALLURE_TOKEN=$(cat ../../secrets/token.txt)
ALLURE_ENDPOINT=$(cat ../../secrets/endpoint.txt)
pageSize=2000
countPage=0
lastPage=false
FILE_PROJECTS_LIST=all-projects.txt

# Clear and go
clear

# echo "ALLURE_ENDPOINT: ${ALLURE_ENDPOINT}"
# echo "ALLURE_TOKEN: ${ALLURE_TOKEN}"

# saving some compute by using Bearer token
JWT_TOKEN=$(curl -s -X POST "${ALLURE_ENDPOINT}/api/uaa/oauth/token" \
     --header "Expect:" \
     --header "Accept: application/json" \
     --form "grant_type=apitoken" \
     --form "scope=openid" \
     --form "token=${ALLURE_TOKEN}" \
     | jq -r .access_token)

# Clear prev runs
rm ${FILE_PROJECTS_LIST}

# get projects
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

# load new projects list
echo "Reading the list of projects from file ${FILE_PROJECTS_LIST}"
PROJECTS=$(<${FILE_PROJECTS_LIST})

# do stuff
for PROJECT in ${PROJECTS}; do
    RESPONSE=$(curl -sS -X GET "${ALLURE_ENDPOINT}/api/testcase?projectId=${PROJECT}&page=0&size=1" --header "accept: */*" --header "Authorization: Bearer ${JWT_TOKEN}")
    totalElements=$(jq .totalElements <<< $RESPONSE)
    # echo "${PROJECT} has elements: ${totalElements}"
    if [ ${totalElements} -eq 0 ]; then
        echo "${PROJECT} is empty - deleting"
        curl -X DELETE "${ALLURE_ENDPOINT}/api/project/${PROJECT}" --header "accept: */*" --header "Authorization: Bearer ${JWT_TOKEN}"
    fi
done
