class Team < ApplicationRecord
	has_many :members
	has_many :games
	has_many :team_plays
	has_many :team_stats
	has_many :posts
	has_many :opponents
end
