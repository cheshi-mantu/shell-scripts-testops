ALLURE_TOKEN=$(cat ../../secrets/testing-token.txt)
ALLURE_ENDPOINT=$(cat ../../secrets/testing-endpoint.txt)
pageSize=2000
countPage=0
lastPage=false
FILE_PROJECTS_LIST=$1

if [ -z $1 ]; then
	echo "Usage: $0 <file_with_projects>"
	exit 1
else
	echo "Reading the list of projects from file ${FILE_PROJECTS_LIST}"
	PROJECTS=$(<${FILE_PROJECTS_LIST})
	echo "Projects: ${PROJECTS}"
	for PROJECT in ${PROJECTS}; do
		echo "Working with project ${PROJECT}"
	done
fi


