#!/bin/bash

echo "Getting Allure TestOps version from .env"
VERSION_STRING=$(awk 'NR==1' .env)
ARR_VER=(${VERSION_STRING//=/ })
TESTOPS_VERSION=${ARR_VER[1]}
echo "Allure TestOps version from .env is $TESTOPS_VERSION"


#getting the list of all the docker containers

SERVICES_LIST=$(docker-compose config --services)

echo "Trying to get the log for these services: ${SERVICES_LIST}"

TIME_STAMP=$(date +%Y%m%d-%H%M%S)

for SERVICE in $SERVICES_LIST
do
  docker-compose logs $SERVICE > $SERVICE-logs-$TIME_STAMP.txt
  echo "Saved logs to $SERVICE-logs-${TIME_STAMP}.txt"
done

# getting data on the queues in RabbitMQ

RABBIT_LOG=$(docker-compose exec -u root report-mq rabbitmqctl list_queues -p report)

cat << EOF >> rabbit-queues-${TIME_STAMP}.txt
${RABBIT_LOG}
EOF

echo "Saved logs to rabbit-queues-${TIME_STAMP}.txt"

# creating single archive
ARCHIVE=$(date +%Y%m%d-%H%M)-testops-$TESTOPS_VERSION.tar.gz
echo "Creating single archive with all logs - ${ARCHIVE}"

tar czf ./${ARCHIVE} ./*.txt

if [ "$?" -eq "0" ]
then
  rm -f ./*.txt
fi

echo "Now, you can restart your Allure TestOps installation"
echo "1. docker-compose down"
echo "2. docker-compose up -d"
