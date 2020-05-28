class Plays::NewPlayService
	def initialize(params)
		@play_type_string = params[:play_type_string]
		@play_name = params[:play_name]
		@is_offense = params[:is_offense]
		@user_id = params[:user_id]
		@json_diagram = params[:json_diagram]
		@canvas_width = params[:canvas_width]
		@team_id = params[:team_id]
		@play_image = params[:play_image]
		@member_id = params[:member_id]
	end

	def call()

		play = Play.new(
			name: @play_name,
			user_id: current_user.id,
			num_progressions: 1,
			play_type_id: params[:play_type],
		)

		play.save!


		member = Member.where(user_id: current_user.id, team_id: team_id).take

		progression = Progression.new(
			index: 0, 
			play_id: play.id, 
		)

		progression.save
		render :json => {id: progression.id}

		notif = Notification.create(
			content: "New play: " + @play_name + " created",
			team_id: @team_id,
			notif_type_type: "Play",
			notif_type_id: play.id,
			notif_kind: "created"
		)

		prog_notif = Notification.create(
			content: "1 progression added for " + @play_name,
			team_id: @team_id,
			notif_type_type: "Play",
			notif_type_id: play.id,
			data: {"count" => 1},
			notif_kind: "added"
		)

		progression_str = play.name + "1.png"
		param_data = @play_image
		image_data = Base64.decode64(param_data['data:image/png;base64,'.length .. -1])
		image = MiniMagick::Image.read(image_data)
		image.format("png")

		progression.play_image.attach(io: StringIO.new(image.to_blob), filename: progression_str, content_type: "image/jpeg")
		progression.save


		members = Member.where(team_id: @team_id)
		members.each do |team_member|
			if team_member.id != member_id
				MemberNotif.create(
					member_id: team_member.id,
					notification_id: notif.id,
					viewed: false,
					read: false,
				)
				MemberNotif.create(
					member_id: team_member.id,
					notification_id: prog_notif.id,
					viewed: false,
					read: false,
					data: {"progression_ids" => [progression.id]}
				)
			else
				MemberNotif.create(
					member_id: team_member.id,
					notification_id: notif.id,
					viewed: true,
					read: true,
				)
				MemberNotif.create(
					member_id: team_member.id,
					notification_id: prog_notif.id,
					viewed: false,
					read: false,
					data: {"progression_ids" => [progression.id]}
				)

			end
		end
	end
end