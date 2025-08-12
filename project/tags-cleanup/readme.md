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
