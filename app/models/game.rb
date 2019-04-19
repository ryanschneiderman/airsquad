class Game < ApplicationRecord
	belongs_to :team
	has_many :stats
	has_many :stat_granules
	has_one :opponent
end
