class PracticeStatTotal < ApplicationRecord
	belongs_to :practice
	belongs_to :team
	belongs_to :stat_list
	belongs_to :season
end
