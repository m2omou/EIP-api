class AddPlatformIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :platform_id, :integer
  end
end
