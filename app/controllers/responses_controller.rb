class ResponsesController < ApplicationController
  require "openai"
  client = OpenAI::Client.new(access_token: ENV['RAILS_OPENAI_API_KEY'])

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
