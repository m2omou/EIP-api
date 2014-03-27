class CreateAlphaUsers < ActiveRecord::Migration
  def change
    create_table :alpha_users do |t|
      t.string :email
      t.datetime :subscribe_at

      t.timestamps
    end
  end
end
