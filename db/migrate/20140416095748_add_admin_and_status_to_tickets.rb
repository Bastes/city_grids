class AddAdminAndStatusToTickets < ActiveRecord::Migration
  def change
    change_table :tickets do |t|
      t.string :admin
      t.string :status
      t.index :status
    end
  end
end
