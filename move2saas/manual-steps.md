# Data preparation for moving demo docker compose deployment to SaaS

Minimal release of Allure TestOps deployed locally is 3.193.x, if your release is less, you need to upgrade to 3.193 or to the most recent release, then start these steps.

## Preparations

> All the users need to log out from Allure TestOps UI

### Step one - directory

Go to docker compose config files dir, this is the directory form where you are starting Allure TestOps, i.e. where `docker-compose.yml` and `.env` reside.

## Create backup directories

```bash
mkdir -p ${PWD}/backup/databases
mkdir -p ${PWD}/backup/s3
```

## Get names of services

This is required for next steps to prevent users working with the instance.

```shell
docker compose ps
```

the command will result in similar output

```shell
NAME                IMAGE     COMMAND     SERVICE             CREATED             STATUS                   PORTS
allure-gateway      <image>   <command>   allure-gateway      7 minutes ago       Up 7 minutes (healthy)   0.0.0.0:10777->8080/tcp
allure-report       <image>   <command>   allure-report       7 minutes ago       Up 7 minutes (healthy)   
allure-uaa          <image>   <command>   allure-uaa          7 minutes ago       Up 7 minutes (healthy)   
rabbitmq            <image>   <command>   rabbitmq            7 minutes ago       Up 7 minutes             4369/tcp, 5671-5672/tcp, 
redis               <image>   <command>   redis               7 minutes ago       Up 7 minutes (healthy)   6379/tcp
minio-local         <image>   <command>   minio-local         58 seconds ago      Up 10 seconds            0.0.0.0:9000->9000/tcp
report-db           <image>   <command>   report-db           58 seconds ago      Up 57 seconds                      5432/tcp
uaa-db              <image>   <command>   uaa-db              58 seconds ago      Up 57 seconds                      5432/tcp
```

Information we need is in the column `SERVICE`. If you are using outdated config files, the names of the services could differ from the example above and all following commands using the services names need to be updated accordingly to your output.

## Stop Allure TestOps services

This will prevent users interactions with the system

```bash
docker compose stop allure-gateway
```

## Get the names of the containers with databases and S3

From the result of `docker compose ps` you need to take the names of the services:

- `uaa-db` - the database container of `uaa` service
- `report-db` - the database container of `report` service
- `minio-local` - the artifacts storage

## Get the usernames and passwords for the databases

```bash
docker compose config | grep -e 'uaa:\|report:\|SPRING_DATASOURCE_USERNAME:\|SPRING_DATASOURCE_PASSWORD:'
```

the output will be like the following:

```bash
 report:
      SPRING_DATASOURCE_PASSWORD: P@assw0rd
      SPRING_DATASOURCE_USERNAME: report
    image: <image>
  uaa:
      SPRING_DATASOURCE_PASSWORD: P@assw0rd
      SPRING_DATASOURCE_USERNAME: uaa
    image: <image>
```

So, you will see which username/password is for which service

Just in case.

## Making the databases dump

### REPORT service database dump

We are executing this command for the `report-db` service referenced earlier as **report-db**. You need to use the real name of the service you have if it differs from the examples.

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
docker cp minio-local:/data/. ${PWD}/backup/s3
```

### Delete all the possible unnecessary files from s3 backup related to min.io

```bash
rm -frd ${PWD}/backup/s3/.minio.sys \
rm -frd ${PWD}/backup/s3/.root_password \
rm -frd ${PWD}/backup/s3/.root_user
```

## Create an archive with all the backup data

```bash
tar -zcvf testops2cloud.tar.gz backup/
```

## Provide data to the tech support as a link to cloud storage

1. Upload created archive to a cloud storage (Google Drive, OneDrive whatsoever)
2. Share to "anyone with the link" as reader.
3. Provide the link to tech support via [https://help.qameta.io](https://help.qameta.io)
4. Provide the information on the installed release (it's very important!!!).
