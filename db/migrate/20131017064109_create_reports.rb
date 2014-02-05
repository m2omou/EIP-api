class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer   :publication_id
      t.integer   :user_id
      t.timestamps
    end
  end
end
