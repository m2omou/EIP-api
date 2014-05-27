class ChangePlaceIdTypeInFollowedPlaces < ActiveRecord::Migration
  def change
    change_column :followed_places, :place_id, :string
  end
end
