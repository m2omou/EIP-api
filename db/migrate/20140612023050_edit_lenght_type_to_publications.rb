class EditLenghtTypeToPublications < ActiveRecord::Migration
  def change
    change_column :publications, :type, :integer, :limit => nil
  end
end
