class AddThumbUrlToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :thumb_url, :string
  end
end
