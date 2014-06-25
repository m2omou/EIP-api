class EditLongitudeToPublication < ActiveRecord::Migration
  def change
    rename_column :publications, :longitude, :user_longitude
    rename_column :publications, :latitude, :user_latitude
  end
end
