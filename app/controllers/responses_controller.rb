class ResponsesController < ApplicationController
  before_action :redirect_root

  def index
    @responses = current_user.responses
  end

  def show
    @response = Response.find(params[:id])
  end

  def new
    @response = Response.new
  end

  def edit; end

  def create
    player_name = response_params.delete(:player_name)
    player = Player.create(name: player_name)
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

    if current_user.can_call_api?
      begin
        if @response.call_api(current_user)
          flash[:notice] = "記録を作成しました"
          redirect_to @response
        end
      rescue StandardError => e
        flash.now[:danger] = e.message
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:danger] = 'API利用回数が上限に達しました。午前5時に利用回数がリセットされます'
      render :new, status: :unprocessable_entity
    end
  end

  def update; end

  def destroy
    @response = Response.find(params[:id])
    if @response.destroy
      flash[:notice] = '投稿が削除されました'
    else
      flash[:error] = '投稿の削除に失敗しました'
    end
    redirect_to request.referer
  end

  private

  def response_params
    params.require(:response).permit(:title, :user_id, :player_name, :team_id, :request_id, :season_id)
  end
end
