class StatList < ApplicationRecord
	has_many :stats
	has_many :stat_granules
	has_many :team_stats
	has_many :stat_totals
	has_many :season_stats
	has_many :team_season_stats
	has_many :season_team_adv_stats
	has_many :advanced_stats
	has_many :team_advanced_stats
	has_many :season_advanced_stats
	has_many :lineup_stats
	has_many :lineup_adv_stats
	has_many :opponent_granules
end
