class PlaylistClass < ActiveRecord::Migration[5.2]
  def change
  	add_column :playlists, :color_scheme, :integer
  end
end
