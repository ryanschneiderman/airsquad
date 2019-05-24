class Team < ApplicationRecord
	has_many :members
	has_many :games
	has_many :team_plays
	has_many :team_stats
	has_many :posts
	has_many :opponents
	has_many :team_advanced_stats
	has_many :season_team_stats
end
