class AddUuiddToAplhaUsers < ActiveRecord::Migration
  def change
    add_column :alpha_users, :uuid, :string
    
  end
end
