class CreateActivity < ActiveRecord::Migration
  def change 
    create_table :activities do |t|
      t.boolean :tagged
      t.string :tag
      t.text :content
      t.boolean :notify, :default => false
      t.string :kind
      t.string :overview, :null => false
      t.integer :user_id, :null => false
      t.integer :department_id
      t.string :status, :default => 'new', :null => false
      t.boolean :repeats, :default => false
      t.integer :repeats_freq, :integer
      t.integer :actionable_id
      t.string :actionable_type
      t.datetime :started, :null => false
      t.datetime :finished
      t.timestamp
    end
  end
end
