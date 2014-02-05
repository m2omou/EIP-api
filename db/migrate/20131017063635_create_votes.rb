class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer   :publication_id
      t.integer   :user_id
      t.boolean   :value
      t.timestamps
    end
  end
end
