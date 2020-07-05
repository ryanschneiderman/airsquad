class LineupGameStat < ApplicationRecord
	belongs_to :stat_list
	belongs_to :lineup
	belongs_to :game
	belongs_to :season
end
