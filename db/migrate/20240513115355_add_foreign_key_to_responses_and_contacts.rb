class AddForeignKeyToResponsesAndContacts < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :responses, :users
    remove_foreign_key :contacts, :users
    add_foreign_key :responses, :users, column: :user_id, on_delete: :cascade
    add_foreign_key :contacts, :users, column: :user_id, on_delete: :cascade
  end
end
