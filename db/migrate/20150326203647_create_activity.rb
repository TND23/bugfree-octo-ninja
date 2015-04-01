class CreateActivity < ActiveRecord::Migration
  def change 
    create_table :activities do |t|
      t.boolean :tagged
      t.string :tag
      t.text :content
      t.string :overview, :null => false
      t.integer :user_id, :null => false
      t.timestamp
    end
  end
end
