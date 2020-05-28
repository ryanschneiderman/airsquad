class AddTeamsToPlaylist < ActiveRecord::Migration[5.2]
  def change
  	add_reference :playlists, :team, index: true
  end
end
