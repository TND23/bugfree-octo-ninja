class EditActivities < ActiveRecord::Migration
  def up
    add_column :activities, :status, :string, :default => 'new', :null => false
  end

  def down
    remove_column :activities, :status
  end
end
