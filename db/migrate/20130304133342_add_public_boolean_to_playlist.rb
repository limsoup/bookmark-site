class AddPublicBooleanToPlaylist < ActiveRecord::Migration
  def change
  	add_column :playlists, :public, :boolean
  end
end
