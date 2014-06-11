class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.integer :allow_messages
      t.integer :send_notification_for_comments
      t.integer :send_notification_for_messages
      t.integer :user_id

      t.timestamps
    end
  end
end
