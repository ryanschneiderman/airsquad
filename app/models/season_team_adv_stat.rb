class SeasonTeamAdvStat < ApplicationRecord
	belongs_to :stat_list
	belongs_to :team
	belongs_to :season
end
