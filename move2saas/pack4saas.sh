#!/bin/bash
clear

TIME_STAMP=$(date +%Y%m%d-%H%M)

echo "Getting docker-compose config"
CONFIG=$(docker-compose config)

RELEASE=$(echo "${CONFIG}" | grep 'allure/allure-uaa')
RELEASE=(${RELEASE//\:/ })
RELEASE=${RELEASE[2]}

echo "Allure TestOps release is ${RELEASE}"

echo "Creating folders"
mkdir -p ${PWD}/backup/databases
mkdir -p ${PWD}/backup/s3
ls -l ./backup

echo "Stopping the services"
docker-compose stop uaa report gateway

echo "Stopped services:"
docker-compose ps | grep "Exit"

# getting the list of services we need to backup

echo "Gettings containers names"

SERVICES4BACKUP=$(docker-compose ps | grep 'report-db\|uaa-db\|report-s3')

REPORT_DB=$(echo "${SERVICES4BACKUP}" | grep report-db)
UAA_DB=$(echo "${SERVICES4BACKUP}" | grep uaa-db)
REPORT_S3=$(echo "${SERVICES4BACKUP}" | grep report-s3)

REPORT_DB=(${REPORT_DB// / })
UAA_DB=(${UAA_DB// / })
REPORT_S3=(${REPORT_S3// / })

echo "We'll back up the following:"
echo "Database from report service from here: ${REPORT_DB[0]}"
echo "Database from uaa service from here: ${UAA_DB[0]}"
echo "Database from report service from here: ${REPORT_S3[0]}"

sleep 3

yq --version

if [ $? -eq 0 ]; then
    echo "yq is found on this machine trying to parse the config"
    echo "Extracting report's database username"
    R_DB_USERNAME=$(echo "${CONFIG}" | yq e '.services.report.environment.SPRING_DATASOURCE_USERNAME' -)
    # R_DB_PASS=$(echo "${CONFIG}" | yq e '.services.report.environment.SPRING_DATASOURCE_PASSWORD' -)
    echo "Extracting uaa's database username"
    U_DB_USERNAME=$(echo "${CONFIG}" | yq e '.services.uaa.environment.SPRING_DATASOURCE_USERNAME' -)
    # U_DB_PASS=$(echo "${CONFIG}" | yq e '.services.uaa.environment.SPRING_DATASOURCE_PASSWORD' -)
else
    echo "yq is not found on this machine"
    echo "assuming report's database username is report"
    echo "assuming uaa's database username is uaa"
    R_DB_USERNAME=report
    U_DB_USERNAME=uaa
fi    

echo "Dumping report's database using pg_dump -Fc"
docker exec -t ${REPORT_DB} pg_dump -U ${R_DB_USERNAME[0]} report > ${PWD}/backup/databases/report_db_pg_dump.sql

echo "Dumping uaa's database using pg_dump -Fc"
docker exec -t ${UAA_DB} pg_dump -U ${U_DB_USERNAME} uaa > ${PWD}/backup/databases/uaa_db_pg_dump.sql

echo "Creating a copy of S3 files from ${REPORT_S3}"
docker cp ${REPORT_S3}:/data/. ${PWD}/backup/s3

# overriding, if a client has old cfg with FS instead of report-s3


rm -frd ${PWD}/backup/s3/.minio.sys
echo "Creating the single archive fo"
tar -zcvf ${TIME_STAMP}_testops_${RELEASE}.tar.gz backup/
if [ $? -eq 0 ]; then
    echo "Files added successfully, deleting source dir"
    rm -frd backup/
else
    echo "Something went wrong with the archiving, keeping source folder 'backup'"
fi