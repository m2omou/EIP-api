class RemoveFieldNameFromPublications < ActiveRecord::Migration
  def change
    add_column :publications, :longitude, :float
    add_column :publications, :latitude, :float
    add_column :publications, :type, :string
    remove_column :publications, :title
  end
end
