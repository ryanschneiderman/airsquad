class ScheduleEvent < ApplicationRecord
	has_one :game
	belongs_to :team
	has_one :practice
end
