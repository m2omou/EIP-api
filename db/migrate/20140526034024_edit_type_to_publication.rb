class EditTypeToPublication < ActiveRecord::Migration
  def change
    change_column :publications, :type, :integer
  end
end
