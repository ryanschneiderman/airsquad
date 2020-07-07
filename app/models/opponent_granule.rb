class OpponentGranule < ApplicationRecord
	belongs_to :season
	belongs_to :game
	belongs_to :opponent 
	belongs_to :stat_list
end
