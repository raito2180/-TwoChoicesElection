class AddColumnPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :date, :datetime
  end
end
