class LineupsMember < ApplicationRecord
	belongs_to :member 
	belongs_to :lineup
end
