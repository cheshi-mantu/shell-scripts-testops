# Set of scripts to help you with the Allure TestOps docker-compose deployment

## restore deleted test cases

Shell script to restore deleted test cases in a project

### Content
- restore-deleted-tc-in-project.sh 
- README.MD

### Prerequisites

Script requires `jq` tool on the local machine. 

[See here](https://stedolan.github.io/jq/)

install via homebrew:

```shell
brew install jq
```

### How

Make `restore-deleted-tc-in-project.sh` executable

```bash
chmod +x 
```

update the following lines with real data

```shell
ALLURE_TOKEN=<token>
ALLURE_ENDPOINT=https://<testops>
ALLURE_PROJECT_ID=<PROJECT_ID>
RESTORE_TEST_CASES_PER_RUN=100
```

Run `restore-deleted-tc-in-project.sh`

```bash
./restore-deleted-tc-in-project.sh
```
