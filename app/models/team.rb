class Team < ApplicationRecord
	has_many :members
	has_many :games
	has_many :team_plays
	has_many :team_stats
	has_many :posts
	has_many :opponents
	has_many :team_season_stats
	has_many :sesaon_team_adv_stats
	has_many :lineups
	has_many :schedule_events
end
