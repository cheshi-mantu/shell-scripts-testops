ALLURE_TOKEN=$(cat ../secrets/token.txt)
ALLURE_ENDPOINT=$(cat ../secrets/endpoint.txt)
ALLURE_PROJECT_ID=$1



ALL_PROJECTS=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/project?page=0&size=2000" --header "accept: */*" --header "Authorization: Api-Token ${ALLURE_TOKEN}"  | jq .content[].id)



# while ! ${lastPage}; do
# echo "Getting page ${countPage}"

# RESPONSE=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/testcase/__search?projectId=${ALLURE_PROJECT_ID}&rql=${AQL}&deleted=false&page=${countPage}&size=1000&sort=id%2CASC" --header "accept: */*" --header "Authorization: Bearer ${JWT_TOKEN}")

# TEST_CASES="${TEST_CASES}$(jq .content[].id <<< $RESPONSE)"

# lastPage=$(jq .last <<< $RESPONSE)
# echo "Last page = ${lastPage}"
# countPage=$((countPage + 1))
# done
