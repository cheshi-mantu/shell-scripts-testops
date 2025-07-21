# Why

Here I have collected set of shell scripts with examples of the Allure TestOps API calls usage to help ones struggling with the application of the described in swagger.

# How

Allure TestOps has no end-user API calls. All API calls you see in swagger is for the application's Front End only.

- What does it mean?
- It basically means each API call is intended to execute one action and get only the portion of data that FE requires in a certain place of UI. No less and no more.
- And?
- And this also means in the vast majority of cases you won't be able to get all data you might need – from a single API call.

To get the data you need, you need to see where this data is available in the UI and execute API calls in a way FE does it.

Open DevTools, see what FE does and mimic its actions to get all what you need in the FE way.

# Limitations

Allure TestOps uses Spring Boot. All big lists are paginated. The max amount of items can be returned in the scope of one page is 2000. If the request you are using returns more, then you will need to implement the processing of the painated results on your tool side.

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

