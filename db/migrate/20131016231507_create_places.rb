class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.float       :longitude
      t.float       :latitude
      t.string      :name
      t.string      :postcode
      t.string      :city
      t.string      :address
      t.string      :country
      t.timestamps
    end
  end
end
