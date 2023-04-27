require "smoketest_cleanup"# frozen_string_literal: true
require "sequel"

SESSION_DB = Sequel.connect(
  adapter: "mysql2",
  host: ENV.fetch("SESSION_DB_HOST"),
  database: ENV.fetch("SESSION_DB_NAME"),
  user: ENV.fetch("SESSION_DB_USER"),
  password: ENV.fetch("SESSION_DB_PASS"),
  max_connections: 32,
  )

USER_DB = Sequel.connect(
  adapter: "mysql2",
  host: ENV.fetch("USER_DB_HOST"),
  database: ENV.fetch("USER_DB_NAME"),
  user: ENV.fetch("USER_DB_USER"),
  password: ENV.fetch("USER_DB_PASS"),
  max_connections: 32,
  )

SmoketestCleanup.clean
