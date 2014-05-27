class RemoveTableRelationsh < ActiveRecord::Migration
  def change
    drop_table :followed_places
  end
end
