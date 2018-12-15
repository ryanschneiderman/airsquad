class Team < ApplicationRecord
	belongs_to :user
	has_many :players, dependent: :destroy
	has_many :coaches, dependent: :destroy 
end
