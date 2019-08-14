class Member < ApplicationRecord
	belongs_to :user
	has_many :teams
	has_many :stats
	has_many :stat_granules
	has_many :posts
	has_many :season_stats
	has_and_belongs_to_many :lineups
	has_many :assignments  
	has_many :roles, through: :assignments  

end
