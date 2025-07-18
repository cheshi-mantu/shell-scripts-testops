ALLURE_TOKEN=$(cat ../secrets/xyz-token.txt)
ALLURE_ENDPOINT=$(cat ../secrets/xyz-endpoint.txt)

NEW_NAME="Geralt"
NEW_SURNAME="Rivian"
NEW_EMAIL="something@quack.quack"
NEW_USERNAME="geralt"
NEW_PASSWORD="new-new-new-password"
# admin, user, guest
NEW_ROLE="user"

# echo "ALLURE_TOKEN: ${ALLURE_TOKEN}"
# echo "ALLURE_ENDPOINT: ${ALLURE_ENDPOINT}"

BEARER_TOKEN=$(curl -X POST "${ALLURE_ENDPOINT}/api/uaa/oauth/token" \
     --header "Accept: application/json" \
     --form "grant_type=apitoken" \
     --form "scope=openid" \
     --form "token=${ALLURE_TOKEN}" \
     | jq -r .access_token)

echo "Bearer token: ${BEARER_TOKEN}"

NEW_ID=$(curl -X 'POST' "${ALLURE_ENDPOINT}/api/account/register" \
	-H "accept: */*" \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer ${BEARER_TOKEN}" \
	-d "{\"email\": \"${NEW_EMAIL}\",\"firstName\":\"${NEW_NAME}\",\"lastName\":\"${NEW_SURNAME}\",\"password\":\"${NEW_PASSWORD}\",\"username\": \"${NEW_USERNAME}\"}" \
	| jq -r .id)

echo "New user ID: ${NEW_ID}"

curl -X POST "${ALLURE_ENDPOINT}/api/admin/account/${NEW_ID}/activate" \
	-H "accept: */*" \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer ${BEARER_TOKEN}" \
	-d "{\"globalRole\": \"${NEW_ROLE}\"}"
