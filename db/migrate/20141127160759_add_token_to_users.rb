class AddTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :device_token, :string
  end
end
