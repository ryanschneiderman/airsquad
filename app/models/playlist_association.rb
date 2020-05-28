class PlaylistAssociation < ApplicationRecord
	belongs_to :playlist 
	belongs_to :play
end
