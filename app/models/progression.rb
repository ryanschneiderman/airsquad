
class Progression < ApplicationRecord
	belongs_to :play
	has_one_attached :play_image
end
