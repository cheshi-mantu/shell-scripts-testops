# Data preparation for moving standard docker-compose deployment to SaaS

Standard means all the components are running in the containers

## Preparations

> All the users need to log out from Allure TestOps UI

### Step one - directory

Go to docker-compose config files dir, this is the directory form where you are starting Allure TestOps, i.e. where `docker-compose.yml` and `.env` reside.

## Create backup directories

```bash
mkdir -p ${PWD}/backup/database
mkdir -p ${PWD}/backup/s3
```

## Stop Allure TestOps services

```bash
docker-compose stop uaa report gateway
```

## Get the names of the containers with databases and S3

```bash
docker-compose ps
```

the command above will produce similar output (check the comments):

```bash
31860_consul_1      docker-entrypoint.sh agent ...   Up         8300/tcp, 8301/tcp, 8301/udp, 8302/tcp, 8302/udp, 8500/tcp, 8600/tcp, 8600/udp     
31860_gateway_1     java -Djava.security.egd=f ...   Exit 143   # <<<< This is okay, as we have stopped the service                                                                                   
31860_redis_1       docker-entrypoint.sh redis ...   Up         6379/tcp                                                                           
31860_report-db_1   docker-entrypoint.sh postgres    Up         # We need this one 31860_report-db_1 !!!yours will be different!!!                                                                           
31860_report-mq_1   docker-entrypoint.sh rabbi ...   Up         15671/tcp, 15672/tcp, 15691/tcp, 15692/tcp, 25672/tcp, 4369/tcp, 5671/tcp, 5672/tcp
31860_report-s3_1   sh -c mkdir -p /data/allur ...   Up         # we need this one 31860_report-s3_1 !!!yours will be different!!!                                                                           
31860_report_1      java -Djava.security.egd=f ...   Exit 143   # <<<< This is okay, as we have stopped the service                                                                                  
31860_uaa-db_1      docker-entrypoint.sh postgres    Up         # we need this one 31860_uaa-db_1 b!!!yours will be different!!!                                                                         
31860_uaa_1         java -Djava.security.egd=f ...   Exit 143   # <<<< This is okay, as we have stopped the service 
```

- 31860_report-db_1 - will be referenced as **report-db**
- 31860_uaa-db_1 - will be referenced as **uaa-db**
- 31860_report-s3_1 - will be referenced as **report-s3**

## Get the passwords for the databases

```bash
docker-compose config | grep -e 'uaa:\|report:\|SPRING_DATASOURCE_USERNAME:\|SPRING_DATASOURCE_PASSWORD:'
```

the output will be like the following:

```bash
 report:
      SPRING_DATASOURCE_PASSWORD: P@assw0rd
      SPRING_DATASOURCE_USERNAME: report
    image: allure/allure-report:3.186.0
  uaa:
      SPRING_DATASOURCE_PASSWORD: P@assw0rd
      SPRING_DATASOURCE_USERNAME: uaa
    image: allure/allure-uaa:3.186.0
(base) egorivanov@cheshimantu 31860 % 
```
so you will see which username/passport is for which service

Just in case.


## Making the databases dump

### REPORT service database dump

We are executing this command for the report-db container referenced earlier as **report-db**. you need to use the real name of container you have.

```bash
docker exec -t report-db pg_dump -U report report > ${PWD}/backup/databases/report_db_pg_dump.sql
```

Replace **report** in `-U report` with the real name of the DB user if you've changed it during the deployment.

### UAA service database dump

We are executing this command for the report-db container referenced earlier as **report-db**. you need to use the real name of container you have.

Replace **uaa** in `-U uaa` with the real name of the DB user if you've changed it during the deployment.

```bash
docker exec -t uaa-db pg_dump -U uaa uaa > ${PWD}/backup/databases/uaa_db_pg_dump.sql
```

## Backing up the content of S3

We'll need the name of the container with S3 storage referenced as **report-s3** earlier, you need to use the real name of container you have.

### Copy the artifacts

Execute the command:

```bash
docker cp report-s3:/data/. ${PWD}/backup/s3
```

### Delete all the possible unnecessary files from s3 backup related to min.io

```bash
rm -frd ${PWD}/backup/s3/.minio.sys
```

## Create an archive with all the backup data

```bash
tar -zcvf testops2cloud.tar.gz backup/
```

## Provide data to the tech support as a link to cloud storage

1. Upload created archive to a cloud storage (Google Drive, OneDrive whatsoever)
2. Share to "anyone with the link" as reader.
3. Provide the link to tech support