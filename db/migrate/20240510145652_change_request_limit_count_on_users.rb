class ChangeRequestLimitCountOnUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :request_limit_count, from: nil, to: "0"
  end
end
