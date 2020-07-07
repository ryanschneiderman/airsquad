class Opponent < ApplicationRecord
	belongs_to :game
	belongs_to :team
	has_many :stats  
	has_many :opponent_granules
end
