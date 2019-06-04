class Game < ApplicationRecord
	belongs_to :team
	has_many :stats
	has_many :stat_granules
	has_one :opponent
	has_many :team_advanced_stats
	has_many :advanced_stats
end
