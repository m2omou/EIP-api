class AddCollumnToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :creator_id, :integer
    add_column :conversations, :recipient_id, :integer
    remove_column :conversations, :name
  end
end
