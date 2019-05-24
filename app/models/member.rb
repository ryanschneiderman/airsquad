class Member < ApplicationRecord
	belongs_to :user
	has_many :teams
	has_many :stats
	has_many :stat_granules
	has_many :posts
	has_many :season_stats
end
