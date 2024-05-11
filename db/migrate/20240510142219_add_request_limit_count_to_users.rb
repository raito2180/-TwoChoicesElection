class AddRequestLimitCountToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :request_limit_count, :integer
  end
end
