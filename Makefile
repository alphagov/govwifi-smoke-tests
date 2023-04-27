DOCKER_COMPOSE=docker-compose -f docker-compose.yml
BUNDLE_FLAGS=

build:
ifndef ON_CONCOURSE
	$(DOCKER_COMPOSE) build
endif

lint: build
	$(DOCKER_COMPOSE) run --rm app bundle exec rubocop

test: cleanup
	$(DOCKER_COMPOSE) run --rm \
		-e DOCKER=docker \
		-e GW_USER \
		-e GW_PASS \
		-e GW_2FA_SECRET \
		-e GOOGLE_API_CREDENTIALS \
		-e GOOGLE_API_TOKEN_DATA \
		-e GOVWIFI_PHONE_NUMBER \
		-e NOTIFY_GO_TEMPLATE_ID \
		-e NOTIFY_SMOKETEST_API_KEY \
		-e RADIUS_KEY \
		-e RADIUS_IPS \
		-e SUBDOMAIN \
		app bundle exec rspec system

cleanup: build
	$(DOCKER_COMPOSE) run --rm \
		-e DOCKER=docker \
		-e SESSION_DB_HOST \
		-e SESSION_DB_NAME \
    -e SESSION_DB_USER \
    -e SESSION_DB_PASS \
    -e USER_DB_HOST \
    -e USER_DB_NAME \
    -e USER_DB_USER \
    -e USER_DB_PASS \
		app ruby -I:./lib/cleanup ./lib/cleanup/run_cleanup.rb

stop:
	$(DOCKER_COMPOSE) down -v

shell: build
	$(DOCKER_COMPOSE) run --rm app bundle exec sh

.PHONY: build stop test shell
