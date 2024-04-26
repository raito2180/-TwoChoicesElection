class VideosController < ApplicationController
  require 'google/apis/youtube_v3' #YoutubeV3を使用するために、呼び出す
  before_action :set_youtube, only: [:index, :search]

  def index; end
  def show; end

  def search
   # results = @youtube.list_searches(:snippet, q: params[:keyword], type: 'video', max_results:4)
   # @videos = results.items
   # render :index
  end

private

  def set_youtube
   # @youtube = Google::Apis::YoutubeV3::YouTubeService.new
   # @youtube.key = ENV['YOUTUBE_API_KEY']
   # recommend_keyword = "サッカー マルシャル FW"
   # recommend_results = @youtube.list_searches(:snippet, q: recommend_keyword, type: 'video', max_results:4)
   # @recommend_videos = recommend_results.items
  end
end
