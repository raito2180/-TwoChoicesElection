class CreateResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :responses do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.references :user, null: false, foreign_key: true
      t.references :player, foreign_key: true
      t.references :team, foreign_key: true
      t.references :request, null: false, foreign_key: true
      t.references :season, foreign_key: true

      t.timestamps
    end
  end
end
