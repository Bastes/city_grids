class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :address
      t.string :organizer_email
      t.string :organizer_alias
      t.integer :places
      t.datetime :begins_at
      t.datetime :ends_at
      t.text :abstract
      t.references :city, index: true

      t.timestamps
    end
  end
end
