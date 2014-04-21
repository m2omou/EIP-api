class AddPartToPublications < ActiveRecord::Migration
  def change
    change_column :publications, :place_id,  :string
  end
end
