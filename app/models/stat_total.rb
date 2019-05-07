class StatTotal < ApplicationRecord
	belongs_to :team
	belongs_to :game
	belongs_to :stat_list
end
