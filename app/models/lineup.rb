class Lineup < ApplicationRecord
	has_and_belongs_to_many :members
	belongs_to :team
end
