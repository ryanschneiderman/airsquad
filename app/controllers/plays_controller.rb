class PlaysController < ApplicationController
	def index
		if params[:team_id]
			@curr_member =  Assignment.joins(:role).joins(:member).select("roles.name as role_name, members.*").where("members.user_id" => current_user.id, "members.team_id" => params[:team_id])
			@is_admin = false
			@curr_member.each do |member_obj|
				if member_obj.role_name == "Admin"
					@is_admin = true
				end
			end
			cookies[:team_id] = params[:team_id] 
			@team_id = params[:team_id]

			@half_offensive_plays = Play.joins(:team_plays, :play_type).select("play_types.play_type as p_type, team_plays.team_id as team_id, plays.*").where("plays.offense_defense" => true, "team_plays.team_id"=>params[:team_id], "play_types.play_type" => "Halfcourt")
			@full_offensive_plays = Play.joins(:team_plays, :play_type).select("play_types.play_type as p_type, team_plays.team_id as team_id, plays.*").where("plays.offense_defense" => true, "team_plays.team_id"=>params[:team_id], "play_types.play_type" => "Fullcourt")

			@half_defensive_plays = Play.joins(:team_plays, :play_type).select("play_types.play_type as p_type, team_plays.team_id as team_id, plays.*").where("plays.offense_defense" => false, "team_plays.team_id"=>params[:team_id], "play_types.play_type" => "Halfcourt")
			@full_defensive_plays = Play.joins(:team_plays, :play_type).select("play_types.play_type as p_type, team_plays.team_id as team_id, plays.*").where("plays.offense_defense" => false, "team_plays.team_id"=>params[:team_id], "play_types.play_type" => "Fullcourt")
			
			@half_offensive_progressions = []
			@half_defensive_progressions = []
			@full_offensive_progressions = []
			@full_defensive_progressions = []

			@half_offensive_plays.each do |play|
				half_offensive_progression = Progression.where(:play_id => play.id).sort_by{|e| e.index}
				@half_offensive_progressions.append(half_offensive_progression)
			end

			@full_offensive_plays.each do |play|
				full_offensive_progression = Progression.where(:play_id => play.id)
				@full_offensive_progressions.append(full_offensive_progression)
			end

			@full_defensive_plays.each do |play|
				full_defensive_progression = Progression.where(:play_id => play.id)
				@full_defensive_progressions.append(full_defensive_progression)
			end

			@half_defensive_plays.each do |play|
				half_defensive_progression = Progression.where(:play_id => play.id)
				@half_defensive_progressions.append(half_defensive_progression)
			end

			@member = Member.where(team_id: @team_id, user_id: current_user.id).take
			@play_notifications = Notification.joins(:member_notifs).select("notifications.*, member_notifs.member_id,  member_notifs.data as member_data, member_notifs.id as member_notif_id").where("member_notifs.member_id" => @member.id, "notifications.notif_type_type" => "Play", "member_notifs.read" => false)



			@play_types = PlayType.all()

			@play = Play.new
		else
			@team_id = nil
			cookies[:team_id] = nil
			@plays = Play.where(user_id: current_user.id)
		end	
	end

	def new
		@play = Play.new
		@team_id = params[:team_id]
		@play_type = params[:play_type]
		@offense_defense = params[:is_offense]
		@play_types = PlayType.all()
	end	
	
	##service
	def create
		play_name = params[:play_name]
		is_offense = params[:offense_defense]
		play_type_string = params[:play_type]
		team_id = params[:team_id]
		create_next = params[:create_next]
		member = Member.where(user_id: current_user.id, team_id: team_id).take

		play_type = PlayType.where(play_type: play_type_string).first

		@play = Play.new(
			name: play_name,
			offense_defense: is_offense,
			user_id: current_user.id,
			num_progressions: 1,
			play_type_id: play_type.id,
		)
		@play.save!

		progression = Progression.new(
			json_diagram: params[:json_diagram], 
			index: 1, 
			play_id: @play.id, 
			canvas_width: params[:canvas_width], 
			notes: params[:notes],
		)

		notif = Notification.create(
			content: "New play: " + play_name + " created",
			team_id: team_id,
			notif_type_type: "Play",
			notif_type_id: @play.id,
			notif_kind: "created"
		)

		prog_notif = Notification.create(
			content: "1 progression added for " + play_name,
			team_id: team_id,
			notif_type_type: "Play",
			notif_type_id: @play.id,
			data: {"count" => 1},
			notif_kind: "added"
		)

		progression_str = @play.name + "1.png"
		param_data = params[:play_image]
		image_data = Base64.decode64(param_data['data:image/png;base64,'.length .. -1])
		image = MiniMagick::Image.read(image_data)
		image.format("png")

		progression.play_image.attach(io: StringIO.new(image.to_blob), filename: progression_str, content_type: "image/jpeg")
		progression.save


		members = Member.where(team_id: team_id)
		members.each do |team_member|
			if team_member.id != member.id
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


		

		if params[:team_id]
			@team_play = TeamPlay.new(play_id: @play.id, team_id: params[:team_id])
			@team_play.save
		end

		unless create_next.nil?
			redirect_path = new_team_play_progression_path(team_id: team_id, play_id: @play.id, progression_index: 1)
		else
			redirect_path = team_plays_path(team_id)
		end

		redirect_to redirect_path
	end


	##service
	def show
		param_play = Play.find_by_id(params[:id])
		## make sure to sanitize
		param_play_id = params[:id]
		@team_id = cookies[:team_id]
		if param_play.num_progressions == 0 
			@need_new_progression_link = true
		else 
			@need_new_progression_link = false
		end

		is_user_member = Team.joins(:members).where(members: {team_id: @team_id}).where(members: {user_id: current_user.id})
		
		## ensuring that the page viewer is a member of the team. Probably a better way to do this site wide. 
		if is_user_member.size > 0 || param_play.user_id == current_user.id
			@play = param_play
			@progressions = Progression.where(play_id: @play.id).order(:index)
			@member = Member.where(team_id: @team_id, user_id: current_user.id).take
			@progression_notifications = Notification.joins(:member_notifs).select("notifications.*, member_notifs.member_id, member_notifs.read as read,  member_notifs.data as member_data, member_notifs.id as member_notif_id").where("member_notifs.member_id" => @member.id, "notifications.notif_type_type" => "Play", "member_notifs.read" => false, "notifications.notif_type_id" => param_play_id).select {|i| i.member_data != "{}"}
			@play_notifications = Notification.joins(:member_notifs).select("notifications.*, member_notifs.member_id,  member_notifs.data as member_data, member_notifs.id as member_notif_id").where("member_notifs.member_id" => @member.id, "notifications.notif_type_type" => "Play", "notifications.notif_type_id" => param_play_id).select {|i| i.member_data == "{}" }
			@play_notifications.each do |play|
				MemberNotif.find_by_id(play.member_notif_id).update(read: true)
			end
			@progression_notifications.each do |notif|
				puts "COUNT OF PROGRESSION NOTIFS"
				puts notif.member_data

			end
		else
			redirect_to root_path
		end	
	end

	def edit 
		param_play = Play.find_by_id(params[:id])
		## make sure to sanitize
		param_play_id = params[:id]
		@team_id = cookies[:team_id]

		@play_type = PlayType.find_by_id(param_play.play_type_id)

		if param_play.num_progressions == 0 
			@need_new_progression_link = true
		else 
			@need_new_progression_link = false
		end

		is_user_member = Team.joins(:members).where(members: {team_id: @team_id}).where(members: {user_id: current_user.id})
		
		## ensuring that the page viewer is a member of the team. Probably a better way to do this site wide. 
		if is_user_member.size > 0 || param_play.user_id == current_user.id
			@play = param_play
			@progressions = Progression.where(play_id: @play.id).order(:index)
		else
			redirect_to root_path
		end	
	end

	def update
		play_id = params[:id]
		team_id = params[:team_id]
		play = Play.find_by_id(play_id)
		play_name = play.name
		raw_data = params[:progressions_data]
		raw_data.each do |testing|
			data_cluster = testing[1]
			Progressions::UpdateProgressionsService.new({
				json_diagram: data_cluster[:json_diagram],
				progression_id: data_cluster[:progression_id],
				play_id: play_id,
				team_id: team_id,
				play_name: play_name,
				play_image: data_cluster[:play_image],
				notes: data_cluster[:notes],
				canvas_width: data_cluster[:canvas_width],
				current_user_id: current_user.id
			}).call
		end
		
		redirect_to edit_team_play_path(team_id, play_id)
	end

	def destroy
		play = Play.find_by_id(params[:id])
		team_id = params[:team_id]

		progressions = Progression.where(play_id: play.id).each do |progression|
			progression.destroy
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
