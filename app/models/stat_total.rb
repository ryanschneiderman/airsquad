class StatTotal < ApplicationRecord
	belongs_to :team
	belongs_to :game
	belongs_to :stat_list
	belongs_to :season
end
