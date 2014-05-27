class AddTable < ActiveRecord::Migration
  def change
    create_table :followed_places do |t|
      t.integer :user_id
      t.integer :followed_place_id

      t.timestamps
    end
  end
end
