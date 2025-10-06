TESTOPS_TOKEN=$(cat ../secrets/token.txt)
TESTOPS_ENDPOINT=$(cat ../secrets/endpoint.txt)
TESTOPS_PROJECT_ID=$(cat ../secrets/project.id)

clear

BEARER_TOKEN=$(../auth-bearer/get-bearer-token.sh ${TESTOPS_ENDPOINT} ${TESTOPS_TOKEN})

curl -X POST "${TESTOPS_ENDPOINT}/api/rs/testcase?v2=true" \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer ${BEARER_TOKEN}" \
  -d '{
  "projectId": '"${TESTOPS_PROJECT_ID}"',
  "name": "Manual Test Case with Nested Steps",
  "description": "Test case in one go",
  "scenario": {
    "steps": [
      {
        "type": "body",
        "body": "Step 1: Open application",
        "steps": [
          {
            "type": "body",
            "body": "Step 1.1: Navigate to login page",
            "steps": [
              {
                "type": "body",
                "body": "Step 1.1.1: Verify page URL is correct"
              }
            ]
          }
        ]
      }
    ]
  }
}'