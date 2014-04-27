class AddOrganizerUrlToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :organizer_url, :string
  end
end
