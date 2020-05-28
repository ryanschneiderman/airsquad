class CreatePlaylistAssociations < ActiveRecord::Migration[5.2]
  def change
    create_table :playlist_associations do |t|
      t.belongs_to :play
      t.belongs_to :playlist
      t.timestamps
    end
  end
end
