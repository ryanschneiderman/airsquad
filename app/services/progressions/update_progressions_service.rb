class Progressions::UpdateProgressionsService
	def initialize(params)
		@json_diagram = params[:json_diagram]
		@progression_id = params[:progression_id]
		@play_id = params[:play_id]
		@team_id = params[:team_id]
		@play_name = params[:play_name]
		@play_image = params[:play_image]
		@notes = params[:notes]
		@canvas_width = params[:canvas_width]
		@current_user_id = params[:current_user_id]
	end

	def call()
		play = Play.find_by_id(@play_id)
		member = Member.where(user_id: @current_user_id, team_id: @team_id).take

		notification = Notification.where("notif_type_id = ? AND created_at >= ? AND notif_kind = ?", play.id, Date.today - 1, 'edited').take 
		
		if !notification.nil? 
			notification.update( data: {"count" => notification.data["count"] + 1})
			MemberNotif.where(notification_id: notification.id).each do |notif|
				if notif.member_id != member.id
					notif.update(viewed: false, read: false)
					if !notif.data["progression_ids"].include? @progression_id
						notif.data["progression_ids"].append(@progression_id)
					end
				end
			end
		else
			notif = Notification.create(
				content: "Play: " + @play_name + " edited",
				team_id: @team_id,
				notif_type_type: "Play",
				notif_type_id: play.id,
				data: {"count" => 1},
				notif_kind: "edited"
			)
			members = Member.where(team_id: @team_id)
			members.each do |team_member|
				if team_member.id != member.id
					MemberNotif.create(
						member_id: team_member.id,
						notification_id: notif.id,
						viewed: false,
						read: false,
						data: {"progression_ids" => [@progression_id]}
					)
				else
					MemberNotif.create(
						member_id: team_member.id,
						notification_id: notif.id,
						viewed: true,
						read: true,
						data: {"progression_ids" => []}
					)
				end
			end
		end

		
		#play.update(name: play_name)
		play.save
		progression = Progression.find_by_id(@progression_id)
		

		progression_str = play.name + progression.index.to_s + ".png"

		param_data = @play_image
		image_data = Base64.decode64(param_data['data:image/png;base64,'.length .. -1])
		image = MiniMagick::Image.read(image_data)
		image.format("png")
		progression.play_image.purge

		progression.play_image.attach(io: StringIO.new(image.to_blob), filename: progression_str, content_type: "image/jpeg")

		progression.update(json_diagram: @json_diagram, canvas_width: @canvas_width, notes: @notes)
		progression.save
	end
end