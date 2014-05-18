class DropAdvertisingsTable < ActiveRecord::Migration
  def change
    drop_table :advertisings
  end
end
