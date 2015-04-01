class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :password_digest
      t.string :username, :unique => true, :null => false
      t.string :session_token, :null => false
    end
  end
end
