class StatList < ApplicationRecord
	has_many :stats
	has_many :stat_granules
	has_many :team_stats
	has_many :stat_totals
end
