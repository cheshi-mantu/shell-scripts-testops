# Preparing your Allure TestOps' data to move to SaaS

## You need yq to be installed on your machine

yq is a command line tool that allows you processing of **yaml** files, we'll use it to extract database usernames from the configuration running on your machine.

If you haven't change anything in the configuration you've downloaded, then we'll just assume report's database username will be **report** and uaa's database username will be **uaa**.

If you have altered the usernames or if you aren't sure, it's better consult the people who did the installation and then alter the script or install `yq`.

### yq download and installation

Download and install 'yq' from https://github.com/mikefarah/yq/releases/

Here is an example, but you should check your operating system and use correct binary file instead of `yq_linux_amd64`.

```bash
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq
````

Make 'yq' executable (this could require sudo): 

```bash 
chmod +x /usr/bin/yq
```
## Creating the backup to restore to SaaS

1. Clone this whole repository to the machine and folder where Allure TestOps is running as docker-compose deployment(where .env and docker-compose.yml files placed).

```bash
cd path/to/allure-testops
```
```bash
git clone https://github.com/cheshi-mantu/shell-scripts-testops.git
```

2. Copy `pack4saas.sh` script file to the directory where `docker-compose.yml` and `.env` files reside

```bash
cp ./shell-scripts-testops/move2saas/pack4saas.sh ./pack4saas.sh
```

3. Make shell script executable

```bash
chmod +x pack4saas.sh
```
4. Run the script and get the archive with the database dump and files from S3

```bash
./pack4saas.sh
```
5. Collect the file and share with Qameta's support.
