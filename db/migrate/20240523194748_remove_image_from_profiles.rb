class RemoveImageFromProfiles < ActiveRecord::Migration[7.1]
  def change
    remove_column :profiles, :image, :string
  end
end
