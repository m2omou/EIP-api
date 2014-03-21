class RemoveFileFromPublications < ActiveRecord::Migration
  def change
    remove_column :publications, :file
  end
end
