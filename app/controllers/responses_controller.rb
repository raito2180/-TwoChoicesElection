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
      call_api
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
      flash[:notice] = '投稿が削除されました'
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
    prompt = <<~PROMPT
      最新のサッカー欧州リーグについてです
      初心者が好きになれそうな世界トップクラスの選手簡単な特長・所属クラブチームと共に教えてください
      ポジション毎(ゴールキーパー*1、センターバック*2、右サイドバック*1、左サイドバック*1、セントラルミッドフィルダー*1、右ミッドフィルダー*1、左ミッドフィルダー*1、左ウィングフォワード*1、右ウィングフォワード*1、センターフォワード)に計11人教えてください
      形式以外の文章は不要です。
      マークダウンで出力してください
      日本語で教えてください
      youtubeで見るのにおすすめな選手でお願いします
      形式の例は、以下の通りでお願いします。
      <h3>CF</h3> <p>
        <strong>選手名:</strong> ロベルト・レヴァンドフスキ<br> 
        <strong>所属クラブチーム:</strong> バイエルン・ミュンヘン<br> 
        <strong>特長:</strong> 圧倒的な得点力とポジショニングセンスを誇る点取り屋。</p>
      <h3>RWF</h3> <p>
        <strong>選手名:</strong> キリアン・エムバペ<br> 
        <strong>所属クラブチーム:</strong> パリ・サンジェルマン<br> 
        <strong>特長:</strong> 圧倒的なスピードとドリブルで相手ディフェンスを翻弄する。</p>
      <h3>LWF</h3> <p>
        <strong>選手名:</strong> ネイマール<br> 
        <strong>所属クラブチーム:</strong> パリ・サンジェルマン<br> 
        <strong>特長:</strong> テクニックと創造力で試合の流れを変えるアーティスト。</p>
      <h3>CMF</h3> <p>
        <strong>選手名:</strong> ケビン・デ・ブライネ<br> 
        <strong>所属クラブチーム:</strong> マンチェスター・シティ<br> 
        <strong>特長:</strong> パス精度と視野の広さで攻撃を司るプレーメーカー。</p>
      <h3>RMF</h3> <p>
        <strong>選手名:</strong> ムハンマド・サラー<br> 
        <strong>所属クラブチーム:</strong> リヴァプール<br> 
        <strong>特長:</strong> スピードと得点力を兼ね備えた右サイドのエース。</p>
      <h3>LMF</h3> <p>
        <strong>選手名:</strong> フィル・フォーデン<br> 
        <strong>所属クラブチーム:</strong> マンチェスター・シティ<br>
        <strong>特長:</strong> 技術と創造力に秀でた若手の有望株。</p>
      <h3>CB1</h3> <p>
        <strong>選手名:</strong> ヴィルジル・ファン・ダイク<br> 
        <strong>所属クラブチーム:</strong> リヴァプール<br> 
        <strong>特長:</strong> 圧倒的なフィジカルとリーダーシップを持つディフェンダー。</p>
      <h3>CB2</h3> <p>
        <strong>選手名:</strong> ルベン・ディアス<br><br> 
        <strong>所属クラブチーム:</strong> マンチェスター・シティ<br> 
        <strong>特長:</strong> ボール奪取力と冷静なディフェンスで定評がある実力者。</p> 
      <h3>LSB</h3> <p>
        <strong>選手名:</strong> アンドリュー・ロバートソン<br>
        <strong>所属クラブチーム:</strong> リヴァプール<br>
        <strong>特長:</strong> スタミナと正確なクロスが魅力の攻撃的サイドバック。</p> 
      <h3>RSB</h3> <p>
        <strong>選手名:</strong> トレント・アレクサンダー＝アーノルド<br>
        <strong>所属クラブチーム:</strong> リヴァプール<br>
        <strong>特長:</strong> 精度の高いクロスと抜群の攻撃参加能力。</p> 
      <h3>GK</h3><p>
        <strong>選手名:</strong> アリソン・ベッカー<br>
        <strong>所属クラブチーム:</strong> リヴァプール<br>
        <strong>特長:</strong> 驚異的な反応速度と冷静な判断力で、ゴールを堅守する。</p> 
    PROMPT
    response = @client.chat(
        parameters: {
            model: "gpt-4o",
            messages: [{ role: "user", 
            content: prompt }],
        })
    @response.body = response.dig("choices", 0, "message", "content")
    puts @response.body
  end

  def fetch_score_information(*args)
    search_name = args[0]
    season_name = args[1]
    prompt = <<~PROMPT
      #{search_name}と#{season_name}を参考に成績に加えて大事な試合などのメモリアルな話題を詳しく説明してください。シーズンの指定が無い場合、全体を通しての総評を説明して下さい。
      選手やチーム名は正式名称に修正してください
      シーズンが全体の場合、概要は不要です
      メモリアルな話題は3つ教えてください
      形式以外の文章は不要です
      日本語で教えてください
      形式の例は、以下の通りでお願いします
      <h1>#{search_name}</h1>
      <h2>シーズン: #{season_name}</h2>
      <h2>成績</h2>
      <ul>
        <li>リーグ: </li>
        <li>最終順位: </li>
        <li>成績: </li>
        <li>カップ戦: </li>
      </ul>
      <h2>メモリアルマッチ</h2>
      <h3>メモリアルマッチ1</h3>
      <ul>
        <li></li>
        <li></li>
        <li></li>
      </ul>
      <h3>メモリアルマッチ2</h3>
      <ul>
        <li></li>
        <li></li>
        <li></li>
      </ul>
      <h3>メモリアルマッチ3</h3>
      <ul>
        <li></li>
        <li></li>
        <li></li>
      </ul>
      <h2>総括</h2>
      <ul>
        <li></li>
        <li></li>
        <li></li>
      </ul><br>
    PROMPT
    response = @client.chat(
        parameters: {
            model: "gpt-4o",
            messages: [{ role: "user", 
            content: prompt }],
        })
    @response.body = response.dig("choices", 0, "message", "content")
    puts @response.body
  end
  def fetch_character_information(*args)
    search_name = args[0]
    season_name = args[1]
    prompt = <<~PROMPT
      #{search_name}と#{season_name}を参考にプレースタイルを分かりやすく説明してください。シーズンの指定が無い場合、全体を通しての総評を説明して下さい。
      選手やチーム名は正式名称に修正してください
      シーズンが全体の場合、概要は不要です
      特長は3つ教えてください
      形式以外の文章は不要です
      チームの部分は、選手名が入った場合選手に変更してください
      日本語で教えてください
      形式の例は、以下の通りでお願いします
      <h1>#{search_name}</h1>
    <h2>シーズン: #{season_name}</h2>
    <h2>概要</h2>
    <ul>
      <li>リーグ: </li>
      <li>最終順位: </li>
      <li>成績: </li>
      <li>カップ戦: </li>
    </ul>
    <h2>プレースタイルの特長</h2>
    <h3>守備重視</h3>
    <ul>
      <li></li>
      <li></li>
      <li></li>
    </ul>
    <h3>カウンターアタック</h3>
    <ul>
      <li></li>
      <li></li>
      <li></li>
    </ul>
    <h3>セットプレー活用</h3>
    <ul>
      <li></li>
      <li></li>
      <li></li>
    </ul>
    <h3>フィジカルプレー</h3>
    <ul>
      <li></li>
      <li></li>
      <li></li>
    </ul>
    <h2>総括</h2>
    <ul>
      <li></li>
      <li></li>
      <li></li>
    </ul><br>
    PROMPT
    response = @client.chat(
        parameters: {
            model: "gpt-4o",
            messages: [{ role: "user", 
            content: prompt }],
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
      flash[:notice] = "記録を作成しました"
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
    when 'ベストイレブン'
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
