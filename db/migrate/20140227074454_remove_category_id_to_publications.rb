class RemoveCategoryIdToPublications < ActiveRecord::Migration
  def change
    remove_column :publications, :category_id
    remove_column :publications, :media_id
  end
end
