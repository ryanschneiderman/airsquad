class TeamStat < ApplicationRecord
	belongs_to :team  
	belongs_to :stat_list
end
