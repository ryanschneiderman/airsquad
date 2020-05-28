class Plays::DeletePlayService
	def initialize(params)
		@play_id = params[:play_id]
	end

	def call()
		play = Play.find_by_id(@play_id)

		progressions = Progression.where(play_id: play.id).each do |progression|
			progression.destroy
		end
		playlist_associations = PlaylistAssociation.where(play_id: play.id)
		playlist_associations.each do |assoc|
			assoc.destroy
		end
		notifications = Notification.where(notif_type_id: play.id)
		notifications.each do |notif|
			member_notifs = MemberNotif.where(notification_id: notif.id)
			member_notifs.each do |member_notif|
				member_notif.destroy
			end
			notif.destroy
		end
		play.destroy
		
	end
end