class ChangePlaylistName < ActiveRecord::Migration
  def change
  	rename_column :playlists, :name, :playlist_name
  end
end
