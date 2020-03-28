class MemberNotif < ApplicationRecord
	belongs_to :member
	belongs_to :notification
end
