# Set of API calls to help with Allure TestOps routine

## Creating global and per project cleanup schema

### Content

- `global-cleaner-schema.sh`
- `project-cleaner-schema.sh`
- `README.MD`

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
