GovWifi Smoke Tests
===================

This is a collection of rspec with Capybara tests, using Firefox to access the live application.

Running the tests
-----------------

The tests run in a headless browser inside a Docker container. You need to provide some environment variables:

- `GW_USER` - the email address that can sign in to the admin
- `GW_PASS` - the associated password
- `GW_2FA_SECRET` - the secret contained in the QR code when setting up 2FA
- `GW_SUPER_ADMIN_USER` - the email address of a super user that can sign in to the admin. This is needed to remove end users before running the tests.
- `GW_SUPER_ADMIN_PASS` - the associated password
- `GW_SUPER_ADMIN_2FA_SECRET` - the associated 2FA secret
- `SUBDOMAIN` - the subdomain for your particular environment e.g. `wifi` or `staging.wifi`
- `GOOGLE_API_CREDENTIALS` - token for the Google API.
- `GOOGLE_API_TOKEN_DATA` - token for the Google API.

An example of setting the environment variables
```
export GW_USER=email@address.tld
export GW_PASS=Y0uR_PA55W0rD
export GW_2FA_SECRET=1234567890ABCDEF
export GW_SUPER_ADMIN_USER=superuser@address.tld
export GW_SUPER_ADMIN_PASS=paswd
export GW_SUPER_ADMIN_2FA_SECRET=123
export SUBDOMAIN=wifi
export GOOGLE_API_CREDENTIALS='{"access_token....}'
export GOOGLE_API_TOKEN_DATA='{"web":{....}'
```

When running the smoke tests, ensure that both the super user and the regular admin user that were defined in the environment varianles exist in the admin app.
Furthermore, ensure that the regular admin user is a member of two organisations, where one of the organisations should be called "Automated Test 2"

You can find the values of the environment variables in AWS secrets manager:
- `GW_USER` - deploy/gw_user
- `GW_PASS` - deploy/gw_pass
- `GW_2FA_SECRET` - deploy/gw_2fa_secret
- `GW_SUPER_ADMIN_USER` - deploy/gw_super_admin_user
- `GW_SUPER_ADMIN_PASS` - deploy/gw_super_admin_pass
- `GW_SUPER_ADMIN_2FA_SECRET` - deploy/gw_super_admin_2fa_secret
- `GOOGLE_API_CREDENTIALS` - deploy/google_api_credentials
- `GOOGLE_API_TOKEN_DATA` - deploy/google_api_token_data

Then run the tests:
```make test```

Particularly when running in an automated remote way, these credentials should be for a dummy organisation/account, with limited access.

You can also run outside of Docker - in this case the tests run in "headed" mode - i.e. you can watch them run in the browser. First you should install dependencies:
```
brew install firefox
brew install geckodriver
bundle install
```

Then similar to above, except you run rspec directly:
```
bundle exec rspec
```

Updating The Google API Token
-----------------------------

Instructions for updating the [token](https://github.com/alphagov/govwifi-smoke-tests/blob/363d6827e4eb7763003d0d9f4fd4f4288c6fa28a/smoke-tests-concourse.yml#L136) can be found [here](https://docs.google.com/document/d/1uAaho6jRFUyBT4WRFuDN8pfDmHjfYvG6hT_uo4g1pqA/edit#heading=h.2q4zw5lc8jgj)

Running The Smoke Tests In Our Environments
-------------------------------------------

The smoke tests have now been migrated from Concourse to AWS. Full instructions on how to run and edit the infrastructure around them can be found [here](https://docs.google.com/document/d/1RHNkGxJLr4BPPUlFgqDzCF6mSOXK0Kj2Yfb-GHXXNIA/). You will need to be a member of the GovWifi Team in order to access this guide.
