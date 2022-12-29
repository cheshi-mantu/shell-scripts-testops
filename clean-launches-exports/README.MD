# Set of API calls to help with Allure TestOps routine

## Clean PDF exports

Shell script to clean PDF exports for a designated project

### Content

- `clean-pdf-exports.sh`
- `README.MD`

### Prerequisites

Script requires `jq` tool on the local machine. 

[See here](https://stedolan.github.io/jq/)

install via homebrew:

```shell
brew install jq
```

### How

Make `clean-pdf-exports.sh` executable

```bash
chmod +x clean-pdf-exports.sh 
```

update the following lines with real data

```shell
ALLURE_TOKEN=<token>
ALLURE_ENDPOINT=https://<testops>
ALLURE_PROJECT_ID=<PROJECT_ID>
```

Run `clean-pdf-exports.sh`

```bash
./clean-pdf-exports.sh
```
