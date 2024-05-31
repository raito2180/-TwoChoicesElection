class RemoveColumnStatusInGroups < ActiveRecord::Migration[7.1]
  def change
    remove_column :groups, :status, :integer
  end
end
