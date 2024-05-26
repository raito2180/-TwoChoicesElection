class ChangeNotnullInPosts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :posts, :date, false
  end
end
