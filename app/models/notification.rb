class Notification < ApplicationRecord
	belongs_to :team
	belongs_to :notif_type, :polymorphic => true
	has_many :member_notifs
	has_many :members, through: :member_notifs
end
