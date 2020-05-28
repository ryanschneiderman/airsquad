class Playlist < ApplicationRecord
	belongs_to :team
	has_many :playlist_associations
	has_many :plays, through: :playlist_associations
end
