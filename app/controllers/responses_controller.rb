class ResponsesController < ApplicationController
  before_action :set_openai, only: [:create]

  def index
    @responses = Response.all
  end
  def new
    @response = Response.new
  end

  def create
    player_name = response_params.delete(:player_name)
    player = Player.create(name: player_name)
    user = current_user
    @response = Response.new(response_params)
    @response.player_id = player.id
    @response.user_id = current_user.id
    Rails.logger.debug
    @player_data = Player.where(id: @response.player_id).order(created_at: :desc).first
    @team_data = Team.where(id: @response.team_id).order(created_at: :desc).first
    @request_data = Request.where(id: @response.request_id).order(created_at: :desc).first
    @season_data = Season.where(id: @response.season_id).order(created_at: :desc).first
    # リクエストに関連する情報を取得するメソッドを呼び出す
    if @response.request_id.blank?
      flash.now[:danger] = '知りたい事は必須入力です'
      render :new, status: :unprocessable_entity
      return
    end
  
    case @response.request.name
    when '初心者の方はこちら'
      handle_beginner_request
    when '成績'
      handle_score_request
    when '特長'
      handle_character_request
    else
      flash.now[:danger] = '無効なリクエストです'
      render :new, status: :unprocessable_entity
      return
    end
  end

  def show
    @response = Response.find(params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_openai
    require "ruby/openai"
    @client = OpenAI::Client.new
  end

  def response_params
    params.require(:response).permit(:title, :user_id, :player_name, :team_id, :request_id, :season_id)
  end

  def fetch_beginner_information
    response = @client.chat(
        parameters: {
            model: "gpt-3.5-turbo",
            messages: [{ role: "user", 
            content: "2021年のサッカー欧州リーグについてです。
            初心者が好きになれそうな世界トップクラスの選手を11人、簡単な特長・所属クラブチームと共に教えてください。
            形式は、以下の通りでお願いします。

            選手名:
            所属クラブチーム:
            特長:

            日本語で教えてください
            youtubeで見るのにおすすめな選手でお願いします
            箇条書きでお願いします" }],
        })
    @response.body = response.dig("choices", 0, "message", "content")
    puts @response.body
  end

  def fetch_score_information(*args)
    team_name = args[0]
    player_name = args[1]
    season_name = args[2]
    response = @client.chat(
        parameters: {
            model: "gpt-4-0125-preview",
            messages: [{ role: "user", 
            content: "
            サッカーの欧州リーグについて質問です。
            成績に加えて大事な試合などのメモリアルな話題も導入してください。シーズンの指定が無い場合は、全体を通しての総評を説明して下さい。
            説明の対象は下記のとおりです。
            具体的な点数も含めてください
            1回のチャットごとに記憶をリセットしてください。
            知りたい対象:#{team_name}#{player_name}
            シーズン#{season_name}
            " }],
        })
    @response.body = response.dig("choices", 0, "message", "content")
    puts @response.body
  end
  def fetch_character_information(*args)
    team_name = args[0]
    player_name = args[1]
    season_name = args[2]
    response = @client.chat(
        parameters: {
            model: "gpt-4-0125-preview",
            messages: [{ role: "user", 
            content: "
            サッカーの欧州リーグについて質問です。
            プレースタイルを分かりやすく説明してください。シーズンの指定が無い場合は、選手時代の全体を通しての総評を説明して下さい。
            説明の対象は下記のとおりです。
            1回のチャットごとに記憶をリセットしてください。
            知りたい対象:#{team_name}#{player_name}
            シーズン#{season_name}
            " }],
        })
    @response.body = response.dig("choices", 0, "message", "content")
    puts @response.body
  end

  def handle_beginner_request
    fetch_beginner_information
    save_response_with_redirect_or_render
  end
  
  def handle_score_request
    if @team_data && @player_data.name != ""
      flash.now[:danger] = '選手とチームの情報は同時に入れないでください'
      render :new, status: :unprocessable_entity
      return
    end
  
    if @team_data && @season_data
      fetch_score_information(@team_data.name, @season_data.name)
    elsif @player_data.name != "" && @season_data
      fetch_score_information(@player_data.name, @season_data.name)
    elsif @team_data
      fetch_score_information(@team_data.name)
    else @player_data.name != ""
      fetch_score_information(@player_data.name)
    end
  
    save_response_with_redirect_or_render
  end
  
  def handle_character_request
    if @team_data && @player_data.name != ""
      flash.now[:danger] = '選手とチームの情報は同時に入れないでください'
      render :new, status: :unprocessable_entity
      return
    end
  
    if @team_data && @season_data
      fetch_character_information(@team_data.name, @season_data.name)
    elsif @player_data && @season_data
      fetch_character_information(@player_data.name, @season_data.name)
    elsif @team_data
      fetch_character_information(@team_data.name)
    else @player_data
      fetch_character_information(@player_data.name)
    end
  
    save_response_with_redirect_or_render
  end
  
  def save_response_with_redirect_or_render
    if @response.save
      flash[:success] = "記録を作成しました"
      redirect_to @response
    else
      flash.now[:danger] = '作成失敗'
      render :new, status: :unprocessable_entity
    end
  end
end
