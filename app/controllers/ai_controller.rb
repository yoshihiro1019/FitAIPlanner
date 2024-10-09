# app/controllers/ai_controller.rb
require 'openai'

class AiController < ApplicationController
  def generate_training_plan
    client = OpenAI::Client.new(api_key: ENV['OPENAI_API_KEY'])

    response = client.completions.create(
      model: 'text-davinci-003',
      prompt: "Create a personalized workout plan for someone looking to improve their cardio fitness.",
      max_tokens: 150
    )

    @training_plan = response['choices'].first['text']
    render 'ai/training_plan'
  end
end
