class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.integer     :user_id
      t.integer     :category_id
      t.integer     :media_id
      t.integer     :place_id
      t.string      :title
      t.text        :content
      t.timestamps
    end
  end
end
