class RemoveColumns < ActiveRecord::Migration
  def self.up
    remove_column :users, :password
    remove_column :users, :remember_token
  end

end
