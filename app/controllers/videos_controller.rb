class VideosController < ApplicationController
  require 'google/apis/youtube_v3' # YoutubeV3を使用するために、呼び出す
  before_action :set_youtube, only: [:index, :search]

  def index; end
  def show; end

  def search
    @results = @youtube.list_searches(:snippet, q: "サッカー スーパープレイ #{params[:keyword]}", type: 'video', max_results: 12, order: 'viewCount')
    @videos = @results.items.map do |result|
      video_id = result.id.video_id
      statistics = @youtube.list_videos(:statistics, id: video_id).items.first
      view_count = statistics.statistics.view_count
      {
        title: result.snippet.title,
        video_id:,
        view_count:,
        thumbnail_url: result.snippet.thumbnails.high.url,
        channel_title: result.snippet.channel_title
      }
    end
    render :index
  rescue Google::Apis::ClientError => e
    if e.message.include?('quotaExceeded')
      flash.now[:danger] = "YouTube APIの上限を超えました。PM4:00にリセットされますのでまたお越しください♪"
      render :index, status: :internal_server_error
    end
  rescue StandardError
    render :index, status: :internal_server_error
  end

  private

  def set_youtube
    @youtube = Google::Apis::YoutubeV3::YouTubeService.new
    @youtube.key = ENV.fetch('YOUTUBE_API_KEY', nil)
    recommend_keyword = "サッカー スーパープレイ集"
    begin
      recommend_results = @youtube.list_searches(:snippet, q: recommend_keyword, type: 'video', max_results: 12, order: 'viewCount')
      @recommend_videos = recommend_results.items.map do |result|
        video_id = result.id.video_id
        statistics = @youtube.list_videos(:statistics, id: video_id).items.first
        view_count = statistics.statistics.view_count
        {
          title: result.snippet.title,
          video_id:,
          view_count:,
          thumbnail_url: result.snippet.thumbnails.high.url,
          channel_title: result.snippet.channel_title
        }
      end
    rescue Google::Apis::ClientError => e
      if e.message.include?('quotaExceeded')
        flash.now[:danger] = "YouTube APIの上限を超えました。PM4:00にリセットされますのでまたお越しください♪"
        render :index, status: :internal_server_error
      end
    rescue StandardError
      render :index, status: :internal_server_error
    end
  end
end
