class UserTable < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :access_token
      t.string :lid
      t.string :public_url
      t.string :first_name
      t.string :last_name
      t.timestamp :created_at
    end
    add_index :users, :access_token, :unique => true
    add_index :users, :lid, :unique => true
    add_index :users, :public_url, :unique => true
  end
end
