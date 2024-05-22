class ChangeProfileValidation < ActiveRecord::Migration[7.1]
  def change
    change_column_null :profiles, :name, false
    change_column_null :profiles, :gender, false
    change_column_null :profiles, :image, false
  end
end
