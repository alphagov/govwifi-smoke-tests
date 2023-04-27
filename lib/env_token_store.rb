require "googleauth/token_store"
require "json"

class EnvTokenStore < Google::Auth::TokenStore
  def initialize(env)
    super()
    creds = JSON.parse(env["GOOGLE_API_CREDENTIALS"])
    token = JSON.parse(env["GOOGLE_API_TOKEN_DATA"])

    url = URI("https://accounts.google.com/o/oauth2/token")
    response = Net::HTTP.post_form(url, {
      "refresh_token" => token["refresh_token"],
      "client_id" => creds["web"]["client_id"],
      "client_secret" => creds["web"]["client_secret"],
      "grant_type" => "refresh_token",
    })
    result = JSON.parse(response.body)

    @data = JSON.parse(env["GOOGLE_API_TOKEN_DATA"]).merge({ "access_token" => result["access_token"] }).to_json
  end

  def default
    load("default")
  end

  def load(_id)
    @data
  end

  def store(_id, token)
    puts "GOOGLE_API_TOKEN_DATA='#{token}'" unless ENV["GOOGLE_API_TOKEN_DATA"]
  end
end
