class AddEmailAdminAndActivatedToCities < ActiveRecord::Migration
  def change
    change_table :cities do |t|
      t.string :email
      t.string :admin
      t.boolean :activated, default: false
      t.index :activated
    end
  end
end
