class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.references :group, null: false, foreign_key: { to_table: :groups, on_delete: :cascade }
      t.text :body, null: false

      t.timestamps
    end
  end
end
