GovWifi Smoke Tests
===================

This is a collection of rspec with Capybara tests, using Firefox to access the live application.

Running the tests
-----------------

The tests run in a headless browser inside a Docker container. You need to provide some environment variables:

- `GW_USER` - a email address that can sign in to the admin
- `GW_PASS` - the associated password
- `GW_2FA_SECRET` - the secret contained in the QR code when setting up 2FA
- `SUBDOMAIN` - the subdomain for your particular environment e.g. `wifi` or `staging.wifi`

Particularly when running in an automated remote way, these credentials should be for a dummy organisation/account, with limited access.

```
GW_USER=email@address.tld GW_PASS=Y0uR_PA55W0rD GW_2FA_SECRET=1234567890ABCDEF make test
```

You can also run outside of Docker - in this case the tests run in "headed" mode - i.e. you can watch them run in the browser. First you should install dependencies:

```
brew install firefox
brew install geckodriver
bundle install
```

Then similar to above, except you run rspec directly:

```
GW_USER=email@address.tld GW_PASS=Y0uR_PA55W0rD GW_2FA_SECRET=1234567890ABCDEF bundle exec rspec
```

Updating The Google API Token
-----------------------------

Instructions for updating the [token](https://github.com/alphagov/govwifi-smoke-tests/blob/363d6827e4eb7763003d0d9f4fd4f4288c6fa28a/smoke-tests-concourse.yml#L136) can be found [here](https://docs.google.com/document/d/1uAaho6jRFUyBT4WRFuDN8pfDmHjfYvG6hT_uo4g1pqA/edit#heading=h.2q4zw5lc8jgj)

Running The Smoke Tests In Our Environments
-------------------------------------------

The smoke tests have now been migrated from Concourse to AWS. Full instructions on how to run and edit the infrastructure around them can be found [here](https://docs.google.com/document/d/1RHNkGxJLr4BPPUlFgqDzCF6mSOXK0Kj2Yfb-GHXXNIA/). You will need to be a member of the GovWifi Team in order to access this guide.
