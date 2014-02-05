class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.integer     :type
      t.string      :url
      t.string      :server
      t.timestamps
    end
  end
end
