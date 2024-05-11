if Rails.application.credentials.openai
  OpenAI.configure do |config|
    config.access_token = Rails.application.credentials.openai[:OPENAI_API_KEY]
  end
end