class CreateRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :requests do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
