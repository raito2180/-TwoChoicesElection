class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :detail
      t.string :location
      t.integer :capacity
      t.string :related_url

      t.timestamps
    end
  end
end
