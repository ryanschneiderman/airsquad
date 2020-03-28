class Comment < ApplicationRecord
	belongs_to :post
	belongs_to :member
	has_many :notifications, :as => :notif_type
end
