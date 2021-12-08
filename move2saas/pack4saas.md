#!/bin/bash

echo "Creating folders"
mkdir -p ${PWD}/backup/database
mkdir -p ${PWD}/backup/s3
ls -la ./backup

echo "Stopping the services"
docker-compose stop uaa report gateway

echo "Stopped services:"
docker-compose ps | grep 'Exit'

#getting the list of services we need to backup

docker-compose ps | grep 'report-db\|uaa-db\|report-s3'


docker-compose config | grep -e 'uaa:\|report:\|SPRING_DATASOURCE_USERNAME:\|SPRING_DATASOURCE_PASSWORD:'
docker exec -t report-db pg_dump -Fc -U report report > ${PWD}/backup/databases/report_db_pg_dump.sql
docker exec -t uaa-db pg_dump -Fc -U uaa uaa > ${PWD}/backup/databases/uaa_db_pg_dump.sql
docker cp report-s3:/data/. ${PWD}/backup/s3
rm -frd ${PWD}/backup/s3/.minio.sys
tar -zcvf testops2cloud.tar.gz backup/