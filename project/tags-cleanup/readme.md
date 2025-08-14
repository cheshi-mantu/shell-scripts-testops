# Project tags cleanup

## Use case

When migrating the test cases using the [migration tool](https://qameta.github.io/docs-3p-migration-script/) you will probably have a lot of tags like `testrail:1234` aded to the created test cases.

### Why are there such tags?

Tags like `testrail:1234` are used to avoid the duplication of the created test cases when migration script is passed more than 1 time.

### Do we need these tags?

Most likely no. If you've finalised the migration, then tags can be removed from the test cases.

## Sequence

1. Get the IDs of projects
2. Run cycle for the list of projects
   1. In each project get IDs of tags starting with `testrail:`
   2. Loop through the created list
      1. Delete tags by their IDs

## Yeah, yeah

Script is splitted in several files intentionally – to provide the end user the chance to reign over the process.


## How to

1. Open `delete-project-tags.sh`
2. Alter the value for variable `TAG_PREFIX`
   1. default value is `TAG_PREFIX="testrail:"`
   2. setting the variable to empty string (`TAG_PREFIX=""`) will delete all tags in all projects.
   3. Save file.
3. go to the folder ../../secrets/
   1. create file `endpoint.txt`
      1. add only one line – the URL of your instance, e.g. `https://mytestops.lol`
      2. save
   2. create file `token.txt`
      1. add [API token](https://docs.qameta.io/allure-testops/integrations/jenkins/#21-create-a-token-in-allure-testops)


