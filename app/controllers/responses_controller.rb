class ResponsesController < ApplicationController
  before_action :redirect_root
  before_action :set_openai, only: [:create]

  def index
    @responses = current_user.responses
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

    @player_data = Player.where(id: @response.player_id).order(created_at: :desc).first
    @team_data = Team.where(id: @response.team_id).order(created_at: :desc).first
    @request_data = Request.where(id: @response.request_id).order(created_at: :desc).first
    @season_data = Season.where(id: @response.season_id).order(created_at: :desc).first
    
    # リクエストに関連する情報を取得するメソッドを呼び出す
    if @response.request_id.blank?
      flash.now[:danger] = '知りたい事を入力してください'
      render :new, status: :unprocessable_entity
      return
    end

    if @response.title.blank?
      flash.now[:danger] = 'タイトルを入力してください'
      render :new, status: :unprocessable_entity
      return
    end

    if can_call_api?
      # APIを呼び出す処理
      call_api
      # API利用回数をインクリメント
    else
      flash.now[:danger] = 'API利用回数が上限に達しました。午前5時に利用回数がリセットされます'
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
    @response = Response.find(params[:id])
    if @response.destroy
      flash[:success] = '投稿が削除されました'
    else
      flash[:error] = '投稿の削除に失敗しました'
    end
    redirect_to request.referer
  end

  private

  def set_openai
    require "ruby/openai"
    @client = OpenAI::Client.new
  end

  def response_params
    params.require(:response).permit(:title, :user_id, :player_name, :team_id, :request_id, :season_id)
  end

  def fetch_stardom_information
    response = @client.chat(
        parameters: {
            model: "gpt-4o",
            messages: [{ role: "user", 
            content: "2022年のサッカー欧州リーグについてです
            初心者が好きになれそうな世界トップクラスの選手簡単な特長・所属クラブチームと共に教えてください
            ポジション毎に計11人教えてください
            形式は、以下の通りでお願いします
            形式以外の文章は不要です。
            選手ごとに段落を分けてください

            選手名:
            所属クラブチーム:
            特長:

            日本語で教えてください
            youtubeで見るのにおすすめな選手でお願いします
            " }],
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
            model: "gpt-4o",
            messages: [{ role: "user", 
            content: "
            サッカーの欧州リーグについて質問です。
            成績に加えて大事な試合などのメモリアルな話題も導入してください。シーズンの指定が無い場合は、全体を通しての総評を説明して下さい。
            説明の対象は下記のとおりです。
            具体的な点数も含めてください
            1回のチャットごとに記憶をリセットしてください。
            マークダウン方式は使用しないでください
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
            model: "gpt-4o",
            messages: [{ role: "user", 
            content: "
            サッカーの欧州リーグについて質問です。
            プレースタイルを分かりやすく説明してください。シーズンの指定が無い場合は、選手時代の全体を通しての総評を説明して下さい。
            説明の対象は下記のとおりです。
            1回のチャットごとに記憶をリセットしてください。
            マークダウン方式は使用しないでください
            知りたい対象:#{team_name}#{player_name}
            シーズン#{season_name}
            " }],
        })
    @response.body = response.dig("choices", 0, "message", "content")
    puts @response.body
  end

  def handle_stardom_request
    fetch_stardom_information
    save_response_with_redirect_or_render
    current_user.increment!(:request_limit_count)
  end
  
  def handle_score_request
    if @team_data && @player_data.name != ""
      flash.now[:danger] = '選手とチームの情報は同時に入力しないでください'
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
    current_user.increment!(:request_limit_count)
  end
  
  def handle_character_request
    if @team_data && @player_data.name != ""
      flash.now[:danger] = '選手とチームの情報は同時に入力しないでください'
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
    current_user.increment!(:request_limit_count)
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

  def can_call_api?
    current_user.request_limit_count < 3
  end

  def call_api
    case @response.request.name
    when 'Stardom Players'
      handle_stardom_request
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

end
