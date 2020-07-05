class TeamAdvancedStat < ApplicationRecord
	belongs_to :game
	belongs_to :stat_list
	belongs_to :season
end
