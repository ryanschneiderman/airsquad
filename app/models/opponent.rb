class Opponent < ApplicationRecord
	belongs_to :game
	belongs_to :team
	has_many :stat_granules
	has_many :stats  
end
