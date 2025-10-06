ALLURE_ENDPOINT=$1
ALLURE_TOKEN=$2

if [  -z "${ALLURE_TOKEN}" ]; then
     echo "cannot start without ALLURE_TOKEN"
     echo "Usage: $0 <ALLURE_ENDPOINT> <ALLURE_TOKEN>"
     exit 1
fi


# saving some compute by using Bearer token
JWT_TOKEN=$(curl -s -X POST "${ALLURE_ENDPOINT}/api/uaa/oauth/token" \
     --header "Expect:" \
     --header "Accept: application/json" \
     --form "grant_type=apitoken" \
     --form "scope=openid" \
     --form "token=${ALLURE_TOKEN}" \
     | jq -r .access_token)

echo ${JWT_TOKEN}