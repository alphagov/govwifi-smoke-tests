require "google/apis/gmail_v1"
require "googleauth"
require "json"
require_relative "env_token_store"

class GoogleMail
  APPLICATION_NAME = "GovWifi Smoke Tests".freeze

  SCOPE = [
    Google::Apis::GmailV1::AUTH_GMAIL_SEND,
    Google::Apis::GmailV1::AUTH_GMAIL_MODIFY,
  ].freeze

  def initialize
    @service = Google::Apis::GmailV1::GmailService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize
  end

  def read(query = "")
    messages = @service.list_user_messages("me", q: query).messages
    return if messages.nil?

    message = @service.get_user_message("me", messages[0].id)
    @service.modify_message("me", message.id, Google::Apis::GmailV1::ModifyMessageRequest.new(remove_label_ids: %w[UNREAD]))
    message
  end

  def send_email(to, from, subject, body)
    message = Google::Apis::GmailV1::Message.new
    message.raw = [
      "From: #{from}",
      "To: #{to}",
      "Subject: #{subject}",
      "",
      body,
    ].join("\n")
    @service.send_user_message("me", message)
  end

  def account_email
    @service.get_user_profile("me").email_address
  end

private

  def authorize
    client_id = Google::Auth::ClientId.from_hash JSON.parse(ENV["GOOGLE_API_CREDENTIALS"])
    token_store = EnvTokenStore.new ENV
    authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
    user_id = "default"
    authorizer.get_credentials user_id
  end
end
