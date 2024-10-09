# app/services/gemini_api_client.rb
require 'httparty'

class GeminiApiClient
  include HTTParty
  base_uri 'https://api.gemini.com'  # ここは実際のGEMINI APIのURLに置き換えてください

  def initialize(api_key)
    @headers = {
      "Authorization" => "Bearer #{api_key}",
      "Content-Type" => "application/json"
    }
  end

  def get_data(endpoint)
    self.class.get(endpoint, headers: @headers)
  end

  def post_data(endpoint, body)
    self.class.post(endpoint, headers: @headers, body: body.to_json)
  end
end
