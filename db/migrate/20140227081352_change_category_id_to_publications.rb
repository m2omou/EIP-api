class ChangeCategoryIdToPublications < ActiveRecord::Migration
  def change
    change_column :publications, :content, :text
  end
end
