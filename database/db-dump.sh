#!/bin/bash

if [ -e "docker-compose.yml" ]; then
    yq > /dev/null
    if [ "$?" -eq "0" ]; then

    echo "Getting report's DB connection settings"
    CONFIG=$(docker-compose config)

    DB_URL=$(yq e '.services.report.environment.SPRING_DATASOURCE_URL' - <<< ${CONFIG})
    # TEMP=(${DB_URL//'?'/ })
    TEMP=(${DB_URL//\// })
    DB_URL=${TEMP[1]}

    IP_ADDR=(${DB_URL//\:/ })
    echo "${IP_ADDR[0]}"
    # DB_URL=${DB_URL/jdbc:/''}
    # DB_URL=${DB_URL/postgresql:/''}
    # DB_URL=${DB_URL/'/report'/''}
    echo "DB URL is ${DB_URL}"

    
    
    DB_USERNAME=$(yq e '.services.report.environment.SPRING_DATASOURCE_USERNAME' - <<< ${CONFIG})
    echo "DB USERNAME is ${DB_USERNAME}"

    DB_PASS=$(yq e '.services.report.environment.SPRING_DATASOURCE_PASSWORD' - <<< ${CONFIG})
    echo "DB password is ${DB_PASS}"
    export PGPASSWORD=${DB_PASS}
    
    pg_dump -h ${IP_ADDR[0]} -p ${IP_ADDR[1]} -Fc -U ${DB_USERNAME} report > report_db.sql | tar czf
    
    
    
    
    
    
    else 
        clear
        echo "You need to install 'yq'"
        echo "Please download and install 'yq' from https://github.com/mikefarah/yq/releases/"
        echo "wget https://github.com/mikefarah/yq/releases/download/v4.14.1/yq_linux_amd64 -O /usr/bin/yq"
        echo "Make 'yq' executable: 'chmod +x /usr/bin/yq'"
    fi
else
    echo "docker-compose.yml is not found in current directory please move this file to docker-compose project dir"
fi
