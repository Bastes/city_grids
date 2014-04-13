class AddAdminAndActivatedToTournaments < ActiveRecord::Migration
  def change
    change_table :tournaments do |t|
      t.string  :admin
      t.boolean :activated, default: false
    end

    add_index :tournaments, :activated
  end
end
