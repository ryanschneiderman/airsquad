class LineupStat < ApplicationRecord
	belongs_to :stat_list
	belongs_to :lineup
end