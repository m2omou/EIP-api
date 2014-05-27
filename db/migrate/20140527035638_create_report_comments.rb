class CreateReportComments < ActiveRecord::Migration
  def change
    create_table :report_comments do |t|
      t.integer :comment_id
      t.integer :reason
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
end
