# Mark outdated test cases as OUTDATED

## Tools

The script required `jq` to be installed.

Find more [about `jq` here.](https://github.com/stedolan/jq)

## Content

- `mark-outdated.sh`
   - takes project id and number of days and searches in the project for test cases which weren't updated for number of days.
 - `gl-catch-outdated-test-cases.sh`
   - ugly script to show how the API can be used in gitlab. Do not use it as it is, use as an example instead.
   - script uses authentication which can buzz the uaa service in case of many test cases in the project

### Caveats

1. Automated test is being updated when a launch containing the test results for this test case gets closed.
   1. so if there was no launches with such test results, test case's `lastModifiedDate` will be dated by the most recent test result.
2. If someone added a comment to a test, it's considered updated as well.
3. Same with any attributes

#### Effect

Automated test cases with manual updates within the said number of dates won't be considered as outdated as it's updated manually.

## How to

Script requires 2 parameters:
  
- Project ID
- number of days after which test case needs to be considered as outdated

Example

```shell
./mark-outdated.sh 111 14
```

where 111 is the project ID, and 14 is the number of days.

The ATO Allure TestOps end point and authentication parameters are supplied to script via files.

```shell
ALLURE_TOKEN=$(cat ../secrets/token.txt)
ALLURE_ENDPOINT=$(cat ../secrets/endpoint.txt)
```