class DropCompaniesTable < ActiveRecord::Migration
  def change
    drop_table :companies
    drop_table :media
    drop_table :place_messages
    drop_table :categories
  end
end
