class Response < ApplicationRecord
  attr_accessor :player_name

  belongs_to :user
  belongs_to :player, optional: true
  belongs_to :team, optional: true
  belongs_to :request
  belongs_to :season, optional: true
  with_options presence: true do
    validates :title
    validates :body
  end

  def self.set_openai
    require "ruby/openai"
    OpenAI::Client.new
  end

  def call_api(current_user)
    client = self.class.set_openai
    case request.name
    when 'ベストイレブン'
      handle_stardom_request(client)
    when '成績'
      handle_score_request(client, team, player, season)
    when '特長'
      handle_character_request(client, team, player, season)
    else
      raise StandardError, '無効なリクエストです'
    end

    if save
      current_user.increment!(:request_limit_count) # rubocop:disable all
      true
    else
      raise StandardError, '作成失敗'
    end
  end

  def fetch_stardom_information(client)
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
        <strong>選手名:</strong> ロベルト・レヴァンドフスキ<br>#{' '}
        <strong>所属クラブチーム:</strong> バイエルン・ミュンヘン<br>#{' '}
        <strong>特長:</strong> 圧倒的な得点力とポジショニングセンスを誇る点取り屋。</p>
      <h3>RWF</h3> <p>
        <strong>選手名:</strong> キリアン・エムバペ<br>#{' '}
        <strong>所属クラブチーム:</strong> パリ・サンジェルマン<br>#{' '}
        <strong>特長:</strong> 圧倒的なスピードとドリブルで相手ディフェンスを翻弄する。</p>
      <h3>LWF</h3> <p>
        <strong>選手名:</strong> ネイマール<br>#{' '}
        <strong>所属クラブチーム:</strong> パリ・サンジェルマン<br>#{' '}
        <strong>特長:</strong> テクニックと創造力で試合の流れを変えるアーティスト。</p>
      <h3>CMF</h3> <p>
        <strong>選手名:</strong> ケビン・デ・ブライネ<br>#{' '}
        <strong>所属クラブチーム:</strong> マンチェスター・シティ<br>#{' '}
        <strong>特長:</strong> パス精度と視野の広さで攻撃を司るプレーメーカー。</p>
      <h3>RMF</h3> <p>
        <strong>選手名:</strong> ムハンマド・サラー<br>#{' '}
        <strong>所属クラブチーム:</strong> リヴァプール<br>#{' '}
        <strong>特長:</strong> スピードと得点力を兼ね備えた右サイドのエース。</p>
      <h3>LMF</h3> <p>
        <strong>選手名:</strong> フィル・フォーデン<br>#{' '}
        <strong>所属クラブチーム:</strong> マンチェスター・シティ<br>
        <strong>特長:</strong> 技術と創造力に秀でた若手の有望株。</p>
      <h3>CB1</h3> <p>
        <strong>選手名:</strong> ヴィルジル・ファン・ダイク<br>#{' '}
        <strong>所属クラブチーム:</strong> リヴァプール<br>#{' '}
        <strong>特長:</strong> 圧倒的なフィジカルとリーダーシップを持つディフェンダー。</p>
      <h3>CB2</h3> <p>
        <strong>選手名:</strong> ルベン・ディアス<br><br>#{' '}
        <strong>所属クラブチーム:</strong> マンチェスター・シティ<br>#{' '}
        <strong>特長:</strong> ボール奪取力と冷静なディフェンスで定評がある実力者。</p>#{' '}
      <h3>LSB</h3> <p>
        <strong>選手名:</strong> アンドリュー・ロバートソン<br>
        <strong>所属クラブチーム:</strong> リヴァプール<br>
        <strong>特長:</strong> スタミナと正確なクロスが魅力の攻撃的サイドバック。</p>#{' '}
      <h3>RSB</h3> <p>
        <strong>選手名:</strong> トレント・アレクサンダー＝アーノルド<br>
        <strong>所属クラブチーム:</strong> リヴァプール<br>
        <strong>特長:</strong> 精度の高いクロスと抜群の攻撃参加能力。</p>#{' '}
      <h3>GK</h3><p>
        <strong>選手名:</strong> アリソン・ベッカー<br>
        <strong>所属クラブチーム:</strong> リヴァプール<br>
        <strong>特長:</strong> 驚異的な反応速度と冷静な判断力で、ゴールを堅守する。</p>#{' '}
    PROMPT
    response = client.chat(
      parameters: {
        model: "gpt-4o",
        messages: [{ role: "user",
                     content: prompt }]
      }
    )
    self.body = response.dig("choices", 0, "message", "content")
  end

  def fetch_score_information(client, search_name, season_name = nil)
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
    response = client.chat(
      parameters: {
        model: "gpt-4o",
        messages: [{ role: "user",
                     content: prompt }]
      }
    )
    self.body = response.dig("choices", 0, "message", "content")
  end

  def fetch_character_information(client, search_name, season_name = nil)
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
    response = client.chat(
      parameters: {
        model: "gpt-4o",
        messages: [{ role: "user",
                     content: prompt }]
      }
    )
    self.body = response.dig("choices", 0, "message", "content")
  end

  def handle_stardom_request(client)
    fetch_stardom_information(client)
  end

  def handle_score_request(client, team_data, player_data, season_data)
    raise StandardError, '選手とチームの情報は同時に入力しないでください' if team_data && player_data.name.present?

    if team_data && season_data
      fetch_score_information(client, team_data.name, season_data.name)
    elsif player_data.name.present? && season_data
      fetch_score_information(client, player_data.name, season_data.name)
    elsif team_data
      fetch_score_information(client, team_data.name)
    elsif player_data.name.present?
      fetch_score_information(client, player_data.name)
    end
  end

  def handle_character_request(client, team_data, player_data, season_data)
    raise StandardError, '選手とチームの情報は同時に入力しないでください' if team_data && player_data.name.present?

    if team_data && season_data
      fetch_character_information(client, team_data.name, season_data.name)
    elsif player_data && season_data
      fetch_character_information(client, player_data.name, season_data.name)
    elsif team_data
      fetch_character_information(client, team_data.name)
    elsif player_data
      fetch_character_information(client, player_data.name)
    end
  end
end
