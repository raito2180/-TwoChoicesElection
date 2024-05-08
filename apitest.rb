require "openai"
require 'dotenv'
Dotenv.load

client = client = OpenAI::Client.new(
  access_token: ENV["OPENAI_API_KEY"],
  log_errors: true # Highly recommended in development, so you can see what errors OpenAI is returning. Not recommended in production.
)
    response = client.chat(
        parameters: {
            model: "gpt-3.5-turbo",
            messages: [{ role: "user", 
            content: "2021年のサッカー欧州リーグについてです。
            初心者が好きになれそうなおすすめ選手を11人簡単な特長、所属クラブチームと共に教えてください。
            ポジションはFW,MF,DF,GKをフォーメーション順に教えてください
            youtubeで見るのにおすすめな選手でお願いします
            箇条書きでお願いします" }],
        })
    @response = response.dig("choices", 0, "message", "content")
    puts @response