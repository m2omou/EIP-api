class EditDefaultTypeToSettings < ActiveRecord::Migration
  def change
    change_column :settings, :allow_messages, :boolean, :default => true
    change_column :settings, :send_notification_for_comments, :boolean, :default => true
    change_column :settings, :send_notification_for_messages, :boolean, :default => true
  end
end
