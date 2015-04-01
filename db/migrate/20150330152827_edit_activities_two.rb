class EditActivitiesTwo < ActiveRecord::Migration
  def up
    add_column :activities, :created_at, :datetime
    add_column :activities, :updated_at, :datetime
    add_column :activities, :started, :date, :default => Date.today, :null => false
    add_column :activities, :finished, :date
  end

  def down
    remove_column :activities, :created_at
    remove_column :activities, :updated_at
    remove_column :activities, :started
    remove_column :activities, :finished
  end
end
