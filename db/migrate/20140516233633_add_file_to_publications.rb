class AddFileToPublications < ActiveRecord::Migration
  def change
    add_column :publications, :file, :string
  end
end
