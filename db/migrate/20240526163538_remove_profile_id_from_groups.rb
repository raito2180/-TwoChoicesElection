class RemoveProfileIdFromGroups < ActiveRecord::Migration[7.1]
  def change
    remove_reference :groups, :profile, null: false, foreign_key: true
  end
end
