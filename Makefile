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
		-e GW_ADMIN_USER \
		-e GW_ADMIN_PASS \
		-e GW_ADMIN_2FA_SECRET \
		-e GW_USER \
		-e GW_PASS \
		-e GW_2FA_SECRET \
		-e GOOGLE_API_CREDENTIALS \
		-e GOOGLE_API_TOKEN_DATA \
		-e RADIUS_KEY \
		-e RADIUS_IPS \
		-e SUBDOMAIN \
		app bundle exec rspec

stop:
	$(DOCKER_COMPOSE) down -v

shell: build
	$(DOCKER_COMPOSE)  run --rm \
		-p 1812:1812/udp \
		-p 1813:1813/udp \
		-e DOCKER=docker \
		-e GW_ADMIN_USER \
		-e GW_ADMIN_PASS \
		-e GW_ADMIN_2FA_SECRET \
		-e GW_USER \
		-e GW_PASS \
		-e GW_2FA_SECRET \
		-e GOOGLE_API_CREDENTIALS \
		-e GOOGLE_API_TOKEN_DATA \
		-e RADIUS_KEY \
		-e RADIUS_IPS \
		-e SUBDOMAIN \
		 app bundle exec sh

.PHONY: build stop test shell
