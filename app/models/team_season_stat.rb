class TeamSeasonStat < ApplicationRecord
	belongs_to :stat_list
	belongs_to :team
end
