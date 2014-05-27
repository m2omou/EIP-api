class RenameTableFollowedPlace < ActiveRecord::Migration
  def change
    rename_column :followed_places, :followed_place_id, :place_id
  end
end
