class EditCollumnTypeToSettings < ActiveRecord::Migration
  def change
    change_column :settings, :allow_messages, :boolean
    change_column :settings, :send_notification_for_comments, :boolean
    change_column :settings, :send_notification_for_messages, :boolean
  end
end
