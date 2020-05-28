class Play < ApplicationRecord
	has_many :progressions
	has_many :team_plays
	belongs_to :user
	belongs_to :play_type
	has_many :posts, :as => :post_type
	has_many :notifications, :as => :notif_type
	has_many :playlist_associations
	has_many :playlists, through: :playlist_associations
	has_many :play_views
end
