class AddColumnMailableToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :mailable, :boolean, default: false
  end
end
