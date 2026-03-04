# Set of API calls to help with Allure TestOps routine

## Creating global and per project cleanup schema

### Content

- `global-cleaner-schema.sh`
  - tries to set same clean delay for all the artefacts on global level
- `project-cleaner-schema.sh`
  - tries to set same clean delay for all the artefacts in a given project
- `all-projects-cleaner-schema-create.sh`
  - gets all projects in the instance and tries to set same clean delay for all the artefacts
  - use this one carefully
- `README.MD`

### Preconditions

- [jq is required](https://github.com/stedolan/jq) for some scripts to work



### How

Make `clean-pdf-exports.sh` executable

```bash
chmod +x global-cleaner-schema.sh
chmod +x project-cleaner-schema.sh
```

update the following lines with real data

```shell
ALLURE_TOKEN=<token>
ALLURE_ENDPOINT=https://<testops>
ALLURE_PROJECT_ID=<PROJECT_ID>
```

> `global-cleaner-schema.sh` does not require project ID

Run `global-cleaner-schema.sh` or `project-cleaner-schema.sh`

```bash
./global-cleaner-schema.sh
or
./project-cleaner-schema.sh
```
