class ChangeUserColumnNameActivate < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :activated, :active
  end
end
