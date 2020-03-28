class NotificationsController < ApplicationController
	def viewed
		notifications = params[:notifications]
		if notifications 
			notifications.each do |notif|
				viewed_notif = MemberNotif.find_by_id(notif[1][:id])
				viewed_notif.update(viewed: true)
			end
		end
	end

	def read
		notification_id = params[:notification_id]
		notif = MemberNotif.find_by_id(notification_id)
		notif.update(read: true)
	end

	def get
		if user_signed_in?
			members = Member.where(user_id: current_user.id)
			mem_ids = []
			members.each do |mem|

				mem_ids.push(mem.id)
			end
			@new_notifications = Notification.joins(:member_notifs).select("notifications.*, member_notifs.member_id, member_notifs.viewed, member_notifs.read as read, member_notifs.id as member_notif_id").where("member_notifs.member_id" => mem_ids).sort_by { |n| n.created_at }.reverse! 
			puts "getting notifications"
		end
	end
end
