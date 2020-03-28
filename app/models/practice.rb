class Practice < ApplicationRecord
	belongs_to :team
	has_many :practice_stats
	has_many :practice_stat_granules
	has_many :practice_stat_totals
	belongs_to :schedule_event
	has_many :posts, :as => :post_type
	has_many :notifications, :as => :notif_type
end
