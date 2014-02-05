class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string  :name
      t.string  :email
      t.string  :address
      t.string  :sector
      t.string  :logo
      t.timestamps
    end
  end
end
