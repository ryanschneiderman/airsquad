class Practice < ApplicationRecord
	belongs_to :team
	has_many :practice_stats
	has_many :practice_stat_granules
	has_many :practice_stat_totals
	belongs_to :schedule_event
end
