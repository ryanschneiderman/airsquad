class Stat < ApplicationRecord
	belongs_to :stat_list
	belongs_to :member,  optional: true
	belongs_to :game
	belongs_to :opponent,  optional: true
	belongs_to :season
end
