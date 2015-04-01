class EditUsers < ActiveRecord::Migration
  def up
    add_column :users, :admin, :boolean, :default => false, :null => false
  end

  def down
    remove_column :users, :admin
  end
end
