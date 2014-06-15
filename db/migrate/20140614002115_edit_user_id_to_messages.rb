class EditUserIdToMessages < ActiveRecord::Migration
  def change
    rename_column :messages, :user_id, :sender_id
  end
end
