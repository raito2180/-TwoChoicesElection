namespace :reset_api do
  desc "OPENAIAPI使用回数のリセット"
  task request_limit_count: :environment do
    # 実行したい処理を記述する場所
    User.update_all(request_limit_count: 0) # rubocop:disable all
  end
end
