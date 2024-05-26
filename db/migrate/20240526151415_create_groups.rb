class CreateGroups < ActiveRecord::Migration[7.1]
  def change
    create_table :groups do |t|
      t.references :post, null: false, foreign_key: { to_table: :posts, on_delete: :cascade }
      t.references :profile, null: false, foreign_key: { to_table: :profiles, on_delete: :cascade }
      t.integer :status

      t.timestamps
    end
  end
end
