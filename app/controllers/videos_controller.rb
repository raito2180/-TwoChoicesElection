class VideosController < ApplicationController
  require 'google/apis/youtube_v3' #YoutubeV3を使用するために、呼び出す
  before_action :set_youtube, only: [:index, :search]

  def index; end
  def show; end

  def search
  #  results = @youtube.list_searches(:snippet, q: params[:keyword], type: 'video', max_results:6, order: 'viewCount')
  #  @videos = results.items.map do |result|
  #    video_id = result.id.video_id
  #    statistics = @youtube.list_videos(:statistics, id: video_id).items.first
  #    view_count = statistics.statistics.view_count
  #    {
  #      title: result.snippet.title,
  #      video_id: video_id,
  #      view_count: view_count,
  #      thumbnail_url: result.snippet.thumbnails.high.url
  #    }
  #  end
    render :index
  end

private

def set_youtube
  #@youtube = Google::Apis::YoutubeV3::YouTubeService.new
  #@youtube.key = ENV['YOUTUBE_API_KEY']
  #recommend_keyword = "サッカー スーパープレイ集 ファンタジスタ"
  #recommend_results = @youtube.list_searches(:snippet, q: recommend_keyword, type: 'video', max_results: 6, order: 'viewCount')
  #@recommend_videos = recommend_results.items.map do |result|
  #  video_id = result.id.video_id
  #  statistics = @youtube.list_videos(:statistics, id: video_id).items.first
  #  view_count = statistics.statistics.view_count
  #  {
  #    title: result.snippet.title,
  #    video_id: video_id,
  #    view_count: view_count,
  #    thumbnail_url: result.snippet.thumbnails.high.url
  #  }
  #end
end

end
