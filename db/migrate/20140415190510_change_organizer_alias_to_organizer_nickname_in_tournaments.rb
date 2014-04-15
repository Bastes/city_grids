class ChangeOrganizerAliasToOrganizerNicknameInTournaments < ActiveRecord::Migration
  def change
    rename_column :tournaments, :organizer_alias, :organizer_nickname
  end
end
