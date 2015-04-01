class CreateActivitiesAndTags < ActiveRecord::Migration
  def up
    create_table :activities_tags, :id => false do |t|
      t.belongs_to :activity, :index => true
      t.belongs_to :tag, :index => true
    end
  end

  def down
    drop_table :activities_tags
  end
end
