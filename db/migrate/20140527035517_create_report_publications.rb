class CreateReportPublications < ActiveRecord::Migration
  def change
    create_table :report_publications do |t|
      t.integer :publication_id
      t.integer :reason
      t.text :content
      t.integer :user_id

      t.timestamps
    end
  end
end
