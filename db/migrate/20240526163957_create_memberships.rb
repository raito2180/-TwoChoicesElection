class CreateMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :memberships do |t|
      t.references :profile, null: false, foreign_key: { to_table: :profiles, on_delete: :cascade }
      t.references :group, null: false, foreign_key: { to_table: :groups, on_delete: :cascade }
      t.timestamps
    end
  end
end
