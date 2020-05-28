class Plays::CreatePlayService
	def initialize(params)
		@play_type = params[:play_type]
		@play_name = params[:play_name]
		@is_offense = params[:is_offense]
		@user_id = params[:user_id]
		@json_diagram = params[:json_diagram]
		@canvas_width = params[:canvas_width]
		@team_id = params[:team_id]
		@play_image = params[:play_image]
		@member_id = params[:member_id]
		@playlist_ids = params[:playlist_ids]
	end

	def call()

		play = Play.new(
			name: @play_name,
			user_id: @user_id,
			num_progressions: 1,
			play_type_id: @play_type,
			deleted_flag: false,
		)
		play.save!
		if @playlist_ids
			@playlist_ids.each do |playlist_id|
				playlist = Playlist.find_by_id(playlist_id)
				playlist_association = PlaylistAssociation.new(play: play, playlist: playlist)
				playlist_association.save!
			end
		end

		progression = Progression.new(
			json_diagram: @json_diagram, 
			index: 0, 
			play_id: play.id, 
			canvas_width: @canvas_width, 
		)

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
			if team_member.id != @member_id
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
		Plays::UpdatePlayViewedService.new({play_id: play.id, member_id: @member_id}).call
		return {play_id: play.id, progression_id:  progression.id}
	end
end