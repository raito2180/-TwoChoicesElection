class AddColumnStatusInMembershipss < ActiveRecord::Migration[7.1]
  def change
    add_column :memberships, :status, :integer, default: 0
  end
end
