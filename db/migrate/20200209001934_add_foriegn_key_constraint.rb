class AddForiegnKeyConstraint < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :notes, :users
  end
end
