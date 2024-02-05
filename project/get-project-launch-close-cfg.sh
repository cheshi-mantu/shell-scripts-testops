# this could be a very long process
# Variables
ALLURE_TOKEN=$(cat ../secrets/token.txt)
ALLURE_ENDPOINT=$(cat ../secrets/endpoint.txt)
pageSize=2000
countPage=0
lastPage=false
FILE_PROJECTS_LIST=all-projects.txt
FILE_PROJECTS_CLOSE=all-projects-close-rules.txt
# Clean and go
clear

# echo "ALLURE_ENDPOINT: ${ALLURE_ENDPOINT}"
# echo "ALLURE_TOKEN: ${ALLURE_TOKEN}"

JWT_TOKEN=$(curl -s -X POST "${ALLURE_ENDPOINT}/api/uaa/oauth/token" \
     --header "Expect:" \
     --header "Accept: application/json" \
     --form "grant_type=apitoken" \
     --form "scope=openid" \
     --form "token=${ALLURE_TOKEN}" \
     | jq -r .access_token)


rm ${FILE_PROJECTS_LIST}
rm ${FILE_PROJECTS_CLOSE}


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

echo "Dumping the list of projects to file ${FILE_PROJECTS_LIST}"
cat <<EOF > ${FILE_PROJECTS_LIST}
${PROJECTS}
EOF

echo "Before we continue, please read this carefully"
echo "#########################################################################################################"
echo "Your list contains ${totalElements} elements, this means we are going to make ${totalElements} API calls"
echo "#########################################################################################################"
echo "As an alternative you can edit ${FILE_PROJECTS_LIST} right now, keep only project IDs you are interested in, then press Enter key."

read -p "Press Enter to continue..." name

echo "Reading the list of projects from file ${FILE_PROJECTS_LIST}"
PROJECTS=$(<${FILE_PROJECTS_LIST})

echo

for PROJECT in ${PROJECTS}; do
    echo "${PROJECT}"
    RESPONSE=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/projectsettings/launchclose?projectId=${PROJECT}" --header "accept: */*" --header "Authorization: Bearer ${JWT_TOKEN}")
    FILE_DUMP="${FILE_DUMP}\n${RESPONSE}"
done

echo "Dumping the rules for automatic launches closing to file ${FILE_PROJECTS_CLOSE}"

cat <<EOF > ${FILE_PROJECTS_CLOSE}
${FILE_DUMP}
EOF
clear
echo "Done!"