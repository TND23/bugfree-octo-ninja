class CreateDepartmentsAndUsers < ActiveRecord::Migration
  def up
    create_table :departments_users, :id => false do |t|
      t.belongs_to :department, :index => true
      t.belongs_to :user, :index => true
    end
  end

  def down
    drop_table :departments_users
  end
end
