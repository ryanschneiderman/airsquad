class Play < ApplicationRecord
	has_many :progressions
	has_many :team_plays
	belongs_to :user
end
