class RemoveColumns4 < ActiveRecord::Migration
  def self.up
    remove_column :users, :authentication_token
  end
end
