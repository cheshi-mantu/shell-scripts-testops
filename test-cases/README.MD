# Set of scripts to help you with the Allure TestOps

## restore deleted test cases

Shell script to restore deleted test cases in a project

### Content

- `restore-deleted-tc-in-project.sh`
  - restoration of all deleted test cases in a given project
- `remove-test-keys.sh`
  - remove test key (link to other TMS) from all test cases in a given project
- README.MD

### Prerequisites

Script requires `jq` tool on the local machine. 

[See here](https://stedolan.github.io/jq/)

install via homebrew:

```shell
brew install jq
```

### How

Make `.sh` file executable

Example

```bash
chmod +x restore-deleted-tc-in-project.sh
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
