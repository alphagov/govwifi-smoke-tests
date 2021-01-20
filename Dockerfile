FROM ruby:2.7.2-alpine
ARG BUNDLE_INSTALL_CMD

ENV \
  LANG='C.UTF-8' \
  RACK_ENV=test

WORKDIR /usr/src/app

RUN apk add --no-cache --virtual .build-deps build-base && \
  apk add --no-cache firefox-esr openssl wpa_supplicant

RUN wget -qO - https://github.com/mozilla/geckodriver/releases/download/v0.28.0/geckodriver-v0.28.0-linux32.tar.gz \
  | tar -zxC /usr/bin

COPY Gemfile Gemfile.lock .ruby-version ./
ARG BUNDLE_INSTALL_FLAGS
RUN bundle install --no-cache ${BUNDLE_INSTALL_FLAGS}

RUN apk del .build-deps

COPY . ./
