class AddProfileIdToPosts < ActiveRecord::Migration[7.1]
  def change
    add_reference :posts, :profile, null: false, foreign_key: { to_table: :profiles, on_delete: :cascade }
  end
end
