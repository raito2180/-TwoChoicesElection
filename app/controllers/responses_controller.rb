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
    if @request_data.name == '初心者の方はこちら'
      fetch_beginner_infomation
      if @response.save
        flash[:success] = "Information fetched successfully!"
        redirect_to @response
      else
        flash.now[:danger] = '作成失敗'
        render :new, status: :unprocessable_entity
      end
    elsif @request_data.name == '成績'
      if @team_data && @player_data
      flash.now[:danger] = '選手とチームの情報は同時に入れないでください'
      render :new, status: :unprocessable_entity
      elsif @team_data && @season_data
        fetch_score_infomation(@team_data.name, @season_data.name)
      elsif @player_data && @season_data
        fetch_score_infomation(@player_data.name, @season_data.name)
      elsif @team_data
        fetch_score_infomation(@team_data.name)
      elsif @player_data
        fetch_score_infomation(@player_data.name)
      else 
        flash.now[:danger] = 'シーズンのみの入力は無効です'
        render :new, status: :unprocessable_entity
      end
      if @response.save
        flash[:success] = "Information fetched successfully!"
        redirect_to @response
      else
        flash.now[:danger] = '作成失敗'
        render :new, status: :unprocessable_entity
      end
    else @request_data.name == '特長'
      if @team_data && @player_data
      flash.now[:danger] = '選手とチームの情報は同時に入れないでください'
      render :new, status: :unprocessable_entity
      elsif @team_data && @season_data
        fetch_character_infomation(@team_data.name, @season_data.name)
      elsif @player_data && @season_data
        fetch_character_infomation(@player_data.name, @season_data.name)
      elsif @team_data
        fetch_character_infomation(@team_data.name)
      elsif @player_data
        fetch_character_infomation(@player_data.name)
      else 
        flash.now[:danger] = 'シーズンのみの入力は無効です'
        render :new, status: :unprocessable_entity
      end
      if @response.save
        flash[:success] = "Information fetched successfully!"
        redirect_to @response
      else
        flash.now[:danger] = '作成失敗'
        render :new, status: :unprocessable_entity
      end
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

  def fetch_beginner_infomation
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
  def fetch_score_infomation(team_player_name, season_name)
    response = @client.chat(
        parameters: {
            model: "gpt-3.5-turbo",
            messages: [{ role: "user", 
            content: "
            サッカーの欧州リーグについて質問です。
            成績に加えて大事な試合などのメモリアルな話題も導入してください。
            説明の対象は下記のとおりです。
            1回のチャットごとに記憶をリセットしてください。
            知りたいチーム:#{team_player_name}
            シーズン#{season_name}
            " }],
        })
    @response.body = response.dig("choices", 0, "message", "content")
    puts @response.body
  end
  def fetch_character_infomation(team_player_name, season_name)
    response = @client.chat(
        parameters: {
            model: "gpt-3.5-turbo",
            messages: [{ role: "user", 
            content: "
            サッカーの欧州リーグについて質問です。
            プレースタイルを分かりやすく説明してください。
            説明の対象は下記のとおりです。
            1回のチャットごとに記憶をリセットしてください。
            知りたい選手:#{team_player_name}
            シーズン#{season_name}
            " }],
        })
    @response.body = response.dig("choices", 0, "message", "content")
    puts @response.body
  end

end
