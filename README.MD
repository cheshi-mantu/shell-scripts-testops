# Why

Here I have collected set of shell scripts with examples of the Allure TestOps API calls usage.

# Authentication

Authentication works loke this:

1. [Get Bearer token once.](https://docs.qameta.io/allure-testops/advanced/api/#generation-of-bearer-token)
  - The validity of the Bearer token is pretty long by default, you won't need to re-generate the Bearer token if your API session is less that 24 hrs.
2. [Use the Bearer token](https://docs.qameta.io/allure-testops/advanced/api/#usage-of-bearer-token-for-the-authentication-of-api-requests) to authenticate your further API calls.

## Authentification to don't

Do not be fooled by this in swagger UI:

```shell
curl -X 'GET' \
  'https://demo.testops.cloud/api/some/command/context/path' \
  -H 'accept: */*' \
  -H 'X-XSRF-TOKEN: 11111111-four-four-four-0e406ddebdeb'
```

`-H 'X-XSRF-TOKEN: 11111111-four-four-four-0e406ddebdeb'` if not authentication for API calls. This is how swagger UI works, not the API calls.

