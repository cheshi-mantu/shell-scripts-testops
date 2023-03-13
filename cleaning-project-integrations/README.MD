# Set of API calls to help with Allure TestOps routine

## Removing integrations created during migration from ver. 3 to ver. 4

### Motivation

All the integrations existed before the migration from 3 to 4 are copied to each projects to avoid the interruptions. Although it could create a mess in a single project.

### Content

- `project-clean-integrations.sh`
- `README.MD`

### How

Make `project-clean-integrations.sh` executable

```bash
chmod +x project-clean-integrations.sh
```

update the following lines with real data

```shell
ALLURE_TOKEN=<token>
ALLURE_ENDPOINT=https://<testops>
ALLURE_PROJECT_ID=<PROJECT_ID>
```

then execute the script

```bash
./project-clean-integrations.sh
```
