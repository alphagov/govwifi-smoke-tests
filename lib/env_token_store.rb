require "googleauth/token_store"

class EnvTokenStore < Google::Auth::TokenStore
  def initialize(env)
    @data = env["GOOGLE_API_TOKEN_DATA"]
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
