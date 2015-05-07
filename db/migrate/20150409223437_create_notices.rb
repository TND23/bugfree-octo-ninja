class CreateNotices < ActiveRecord::Migration
  def up
    create_table :notices do |t|
      t.integer :activity_id, :null => false
      t.string :kind
      t.text :content
      t.string :title
    end
  end

  def down
    remove_table :notices
  end
end
