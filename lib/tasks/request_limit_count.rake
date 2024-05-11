namespace :reset_api do
  desc "OPENAIAPI使用回数のリセット" #desc → description（説明）
  task request_limit_count: :environment do #task_nameは自由につけられる
    # 実行したい処理を記述する場所
    User.update_all(request_limit_count: 0)
  end
end
