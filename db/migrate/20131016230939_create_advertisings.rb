class CreateAdvertisings < ActiveRecord::Migration
  def change
    create_table :advertisings do |t|
      t.integer :place_id
      t.integer :company_id
      t.string  :title
      t.string  :type
      t.timestamps
    end
  end
end
