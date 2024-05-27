class ChangeNotnullToPosts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :posts, :title, false
    change_column_null :posts, :detail, false
    change_column_null :posts, :location, false
    change_column_null :posts, :capacity, false
  end
end