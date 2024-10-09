# app/controllers/gemini_controller.rb
class GeminiController < ApplicationController
    def index
      client = GeminiApiClient.new(ENV['GEMINI_API_KEY'])
      response = client.get_data("/v1/some_endpoint")
      
      if response.success?
        @data = response.parsed_response
      else
        @error = "API request failed with code #{response.code}"
      end
    end
  end
  