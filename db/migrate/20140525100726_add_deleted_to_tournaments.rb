class AddDeletedToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :deleted, :boolean, default: false

    add_index :tournaments, :deleted
  end
end
