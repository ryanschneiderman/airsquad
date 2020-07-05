class SeasonStat < ApplicationRecord
	belongs_to :stat_list
	belongs_to :member
	belongs_to :season
end
