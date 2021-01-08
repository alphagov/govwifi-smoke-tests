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
		-e GW_USER \
		-e GW_PASS \
		-e GW_2FA_SECRET \
		-e GMAIL_USER \
		-e GMAIL_PASS \
		app bundle exec rspec

stop:
	$(DOCKER_COMPOSE) down -v

shell: build
	$(DOCKER_COMPOSE) run --rm app bundle exec sh

.PHONY: build stop test shell
