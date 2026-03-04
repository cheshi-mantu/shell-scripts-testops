TESTOPS_TOKEN=$(cat ../secrets/token.txt)
TESTOPS_ENDPOINT=$(cat ../secrets/endpoint.txt)
TESTOPS_PROJECT_ID=10

BEARER_TOKEN=$(../auth-bearer/get-bearer-token.sh ${TESTOPS_ENDPOINT} ${TESTOPS_TOKEN})


ALL_PROJECTS=$(curl -X GET "${TESTOPS_ENDPOINT}/api/rs/project?page=0&size=10000&sort=id%2CASC" --header "accept: */*" --header "Authorization: Bearer ${BEARER_TOKEN}"  | jq .content[].id)

for TESTOPS_PROJECT_ID in ${ALL_PROJECTS}

do 
    echo "\nProject ${TESTOPS_PROJECT_ID}" | tee -a projects-cleanup-existing.txt
    curl -X GET "${TESTOPS_ENDPOINT}/api/rs/cleanerschema?projectId=${TESTOPS_PROJECT_ID}&page=0&size=1000&sort=id%2CASC" --header "accept: */*" --header "Authorization: Bearer ${BEARER_TOKEN}" | tee -a projects-cleanup-existing.txt
done

