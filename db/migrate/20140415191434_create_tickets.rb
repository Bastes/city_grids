class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :email
      t.string :nickname
      t.references :tournament, index: true

      t.timestamps
    end
  end
end
