class ScheduleEvent < ApplicationRecord
	has_one :game
	belongs_to :team
end
