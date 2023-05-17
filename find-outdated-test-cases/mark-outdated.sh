ALLURE_TOKEN=$(cat ../secrets/token.txt)
ALLURE_ENDPOINT=$(cat ../secrets/endpoint.txt)
ALLURE_PROJECT_ID=$1

ACTIVE=-3
OUTDATED=-4


if [[ ! -z ${ALLURE_PROJECT_ID} ]]; then

#get Bearer token for frequent requests 

JWT_TOKEN=$(curl -s -X POST "${ALLURE_ENDPOINT}/api/uaa/oauth/token" \
     --header "Expect:" \
     --header "Accept: application/json" \
     --form "grant_type=apitoken" \
     --form "scope=openid" \
     --form "token=${ALLURE_TOKEN}" \
     | jq -r .access_token)

# requests to contain the following for the authentication
# --header "Authorization: Bearer ${JWT_TOKEN}"

daysBack=$2

if [[ ! -z ${daysBack} ]]; then

backSeconds="$((daysBack*24*60*60))"
unixTimeNow=$(date +%s)
modificationDate="$((unixTimeNow - backSeconds))000"

# # debug
# echo "${backSeconds}"
# echo "${unixTimeNow}"
# echo "${modificationDate}"



# < %3C  
# > %3E
# ( %28
# ) %29


#AQL for <
AQL="%28lastModifiedDate%3C${modificationDate}%29and%28automation%3Dtrue%29"

# AQL for > 
# AQL="%28lastModifiedDate%3E${modificationDate}%29and%28automation%3Dtrue%29"
# echo "${AQL}"


countPage=0
lastPage=false
TEST_CASES=""



# getting all test cases mathcing the criteria defined in ${AQL}
while ! ${lastPage}; do
echo "Getting page ${countPage}"

RESPONSE=$(curl -X GET "${ALLURE_ENDPOINT}/api/rs/testcase/__search?projectId=${ALLURE_PROJECT_ID}&rql=${AQL}&deleted=false&page=${countPage}&size=1000&sort=id%2CASC" --header "accept: */*" --header "Authorization: Bearer ${JWT_TOKEN}")

TEST_CASES="${TEST_CASES}$(jq .content[].id <<< $RESPONSE)"

lastPage=$(jq .last <<< $RESPONSE)
echo "Last page = ${lastPage}"
countPage=$((countPage + 1))
done

echo "${TEST_CASES}" > all_test_cases.txt


# patching test cases matched the criteria
for ID in $TEST_CASES; do

    echo "Patching ${ID} as outdated"
    curl -X PATCH ${ALLURE_ENDPOINT}/api/rs/testcase/${ID} --header "accept: */*" --header "Content-Type: application/json" --header "Authorization: Bearer ${JWT_TOKEN}" -d "{\"statusId\": ${OUTDATED}}"

done

else

    echo "Scripts expects CLI parameters as follows"
    echo "./mark-outdated.sh PROJECT_ID DAYS"

fi


else 
    echo "Scripts expects CLI parameters as follows"
    echo "./mark-outdated.sh PROJECT_ID DAYS"
fi