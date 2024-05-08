class ResponsesController < ApplicationController
  def index
    @responses = Response.find_by(params[:user_id])
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
    binding.pry
    if 
    @player_data = Player.find_by(params[:player_id])
    @team_data = Team.find_by(params[:team_id])
    @request_data = Request.find_by(params[:request_id])
    @season_data = Season.find_by(params[:team_id])
    
    # リクエストに関連する情報を取得するメソッドを呼び出す
    fetch_openai(@player_data.name, @team_data.name, @request_data.name, @season_data.name)
    if @response.save
      flash[:success] = "Information fetched successfully!"
      redirect_to @response
    else
      flash.now[:danger] = '作成失敗'
      render :new, status: :unprocessable_entity
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

  def response_params
    params.require(:response).permit(:title, :user_id, :player_name, :team_id, :request_id, :season_id)
  end

  def fetch_openai(player_name, team_name, request_name, season_name)
    require "ruby/openai"
    client = OpenAI::Client.new
    response = client.chat(
        parameters: {
            model: "gpt-3.5-turbo",
            messages: [{ role: "user", 
            content: "2021年のサッカー欧州リーグについてです。
            初心者が好きになれそうな世界トップクラスの選手を11人ベストイレブン形式で簡単な特長、所属クラブチームと共に教えてください。
            形式は、以下の通りでお願いします。
            ```
            選手名:
            所属クラブチーム:
            特長:
            ```
            youtubeで見るのにおすすめな選手でお願いします
            箇条書きでお願いします" }],
        })
    @response.body = response.dig("choices", 0, "message", "content")
    puts @response.body
  end

end
