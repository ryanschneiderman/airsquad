class GetNotificationsService
	def initialize()
	end

	def call()
		if user_signed_in?
			members = Member.where(user_id: current_user.id)
			mem_ids = []
			members.each do |mem|

				mem_ids.push(mem.id)
			end
			notifications = Notification.joins(:member_notifs).select("notifications.*, member_notifs.member_id, member_notifs.viewed, member_notifs.read as read, member_notifs.id as member_notif_id").where("member_notifs.member_id" => mem_ids).sort_by { |n| n.created_at }.reverse! 
		end
		return notifications
	end
end