class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
        t.string :dept_name, :unique => true, :null => false
    end
  end
end
