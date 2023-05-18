DOCKER_COMPOSE=docker-compose -f docker-compose.yml
BUNDLE_FLAGS=

build:
ifndef ON_CONCOURSE
	$(DOCKER_COMPOSE) build
endif

lint: build
	$(DOCKER_COMPOSE) run --rm app bundle exec rubocop

test: build
	$(DOCKER_COMPOSE) run --rm \
		-e DOCKER=docker \
		-e GW_SUPER_ADMIN_USER \
		-e GW_SUPER_ADMIN_PASS \
		-e GW_SUPER_ADMIN_2FA_SECRET \
		-e GW_USER \
		-e GW_PASS \
		-e GW_2FA_SECRET \
		-e GOOGLE_API_CREDENTIALS \
		-e GOOGLE_API_TOKEN_DATA \
		-e RADIUS_KEY \
		-e RADIUS_IPS \
		-e SUBDOMAIN \
		-e NOTIFY_SMOKETEST_API_KEY \
		-e NOTIFY_GO_TEMPLATE_ID \
		-e GOVWIFI_PHONE_NUMBER \
		-e SMOKETEST_PHONE_NUMBER \
		app bundle exec rspec spec/system

stop:
	$(DOCKER_COMPOSE) down -v

shell: build
	$(DOCKER_COMPOSE) run --rm \
		-e DOCKER=docker \
		-e GW_SUPER_ADMIN_USER \
		-e GW_SUPER_ADMIN_PASS \
		-e GW_SUPER_ADMIN_2FA_SECRET \
		-e GW_USER \
		-e GW_PASS \
		-e GW_2FA_SECRET \
		-e GOOGLE_API_CREDENTIALS \
		-e GOOGLE_API_TOKEN_DATA \
		-e RADIUS_KEY \
		-e RADIUS_IPS \
		-e SUBDOMAIN \
		-e NOTIFY_SMOKETEST_API_KEY \
		-e NOTIFY_GO_TEMPLATE_ID \
		-e GOVWIFI_PHONE_NUMBER \
		-e SMOKETEST_PHONE_NUMBER \
		 app bundle exec sh

.PHONY: build stop test shell
