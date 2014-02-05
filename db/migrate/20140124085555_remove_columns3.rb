class RemoveColumns3 < ActiveRecord::Migration
 def self.up
    remove_column :users, :auth_token
    remove_column :users, :password_reset_token
    remove_column :users, :password_reset_sent_at
  end
end
