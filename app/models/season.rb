class Season < ApplicationRecord
	belongs_to :team
	has_many :games
	has_many :advanced_stats  
	has_many :lineup_adv_stats 
	has_many :lineup_game_advanced_stats 
	has_many :lineup_game_stats 
	has_many :lineup_stats 
	has_many :practice_stat_granules 
	has_many :practice_stat_totals 
	has_many :practice_stats 
	has_many :season_advanced_stats 
	has_many :season_stats 
	has_many :season_team_adv_stats 
	has_many :stat_granules 
	has_many :stat_totals 
	has_many :stats 
	has_many :team_advanced_stats 
	has_many :team_season_stats 
	has_many :members
	has_many :opponent_granules
end
