class PlaysController < ApplicationController
	skip_before_action :authenticate_user!, only: [:play_demo]
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

			##@half_offensive_plays = Play.joins(:team_plays, :play_type).select("play_types.play_type as p_type, team_plays.team_id as team_id, plays.*").where("plays.offense_defense" => true, "team_plays.team_id"=>params[:team_id], "play_types.play_type" => "Halfcourt").sort_by{|e| e.id}
			@all_plays =  Play.joins(:team_plays, :play_type).select("play_types.play_type as p_type, team_plays.team_id as team_id, plays.*").where( "team_plays.team_id"=>params[:team_id], "plays.deleted_flag" => false).sort_by{|e| e.name}
			@all_plays_progressions = []
			@all_plays.each do |play|
				all_plays_progression = Progression.where(:play_id => play.id).sort_by{|e| e.index}
				@all_plays_progressions.append(all_plays_progression)
			end

			@deleted_plays =  Play.joins(:team_plays, :play_type).select("play_types.play_type as p_type, team_plays.team_id as team_id, plays.*").where( "team_plays.team_id"=>params[:team_id], "plays.deleted_flag" => true).sort_by{|e| e.name}
			@deleted_plays_progressions = []
			@deleted_plays.each do |play|
				deleted_plays_progression = Progression.where(:play_id => play.id).sort_by{|e| e.index}
				@deleted_plays_progressions.append(deleted_plays_progression)
			end

			@recently_viewed = Play.joins(:team_plays, :play_views).select("plays.*, team_plays.team_id as team_id, play_views.member_id as member_id, play_views.viewed as viewed").where("team_plays.team_id" => params[:team_id], "plays.deleted_flag" => false).limit(4).sort_by{|e| e.viewed}.reverse!
			@recently_viewed_progressions = []
			@recently_viewed.each do |play|
				recently_viewed_progression = Progression.where(:play_id => play.id).sort_by{|e| e.index}
				@recently_viewed_progressions.append(recently_viewed_progression)
			end

			@recently_updated =  Play.joins(:team_plays).select("team_plays.team_id as team_id, plays.*").where("team_plays.team_id"=>params[:team_id], "plays.deleted_flag" => false).sort_by{|e| e.updated_at}.reverse!.first(4)
			@recently_updated_progressions = []
			@recently_updated.each do |play|
				recently_updated_progression = Progression.where(:play_id => play.id).sort_by{|e| e.index}
				@recently_updated_progressions.append(recently_updated_progression)
			end


			@playlist_arr = []
			@playlists = Playlist.where(team_id: params[:team_id]).sort_by{|e| e.id}
			@playlists.each do |playlist|
				playlist_associations = PlaylistAssociation.joins(:play).select("playlist_associations.*, plays.deleted_flag as deleted_flag").where("playlist_associations.playlist_id" => playlist.id, "plays.deleted_flag" => false)
				playlist_imgs = []
				playlist_associations.each do |playlist_assoc|
					progressions = Progression.where(play_id: playlist_assoc.play_id)
					play = Play.find_by_id(playlist_assoc.play_id)
					progression_img = progressions[0].play_image
					playlist_imgs.push({progression_img: progression_img, play_id: playlist_assoc.play_id, play_name: play.name})
				end
				@playlist_arr.push({playlist: playlist, playlist_imgs: playlist_imgs})
			end
			

			@play_types = PlayType.all()

			#@play = Play.new
		else
			@team_id = nil
			cookies[:team_id] = nil
			@plays = Play.where(user_id: current_user.id)
		end	
	end

	def new
		@play_type = params[:play_type]
		@play_name = params[:play_name]
		@playlists = params[:playlists]
		puts "PRINTING PLAYLISTS"
		puts @playlists

		@play = Play.new(
			name: @play_name,
			user_id: current_user.id,
			num_progressions: 1,
			play_type_id: @play_type,
		)

		progression = Progression.new(
			index: 0, 
			play_id: @play.id, 
		)
		@play_id = @play.id

		##playlist_associations

		@progression_id = progression.id
		puts "@PROGRESSION ID"
		puts @progression_id
		@team_id = params[:team_id]
		#@offense_defense = params[:is_offense]
		@play_types = PlayType.all()
	end	

	def new_play
		team_id = params[:team_id]
		playlists = params[:playlists]
		play_name = params[:play_name]
		play_type = params[:play_type]
		puts "printing in new play"
		puts playlists
		redirect_to new_team_play_path(team_id, playlists: playlists, play_name: play_name, play_type: play_type)
	end
	
	##service
	def create
		play_name = params[:play_name]
		is_offense = params[:offense_defense]
		play_type = params[:play_type]
		team_id = params[:team_id]
		create_next = params[:create_next]
		playlist_ids = params[:playlists]
		member = Member.where(user_id: current_user.id, team_id: team_id).take

		ids = Plays::CreatePlayService.new({
			play_type: play_type,
			play_name: play_name,
			is_offense: is_offense,
			user_id: current_user.id,
			json_diagram: params[:json_diagram],
			canvas_width: params[:canvas_width],
			team_id: team_id,
			play_image: params[:play_image],
			member_id: member.id,
			playlist_ids: playlist_ids
		}).call
		


		if params[:team_id]
			@team_play = TeamPlay.new(play_id: ids[:play_id], team_id: params[:team_id])
			@team_play.save
		end
		render :json => {progression_id: ids[:progression_id], play_id: ids[:play_id]}
	end


	##service
	def show
		param_play = Play.find_by_id(params[:id])
		## make sure to sanitize
		param_play_id = params[:id]
		@play_type = PlayType.find_by_id(param_play.play_type_id)
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
			Plays::UpdatePlayViewedService.new({play_id: @play.id, member_id: @member.id}).call
		else
			redirect_to root_path
		end	
	end

	def edit 
		param_play = Play.find_by_id(params[:id])
		## make sure to sanitize
		param_play_id = params[:id]
		@team_id = cookies[:team_id]


		@play_type = param_play.play_type_id

		if param_play.num_progressions == 0 
			@need_new_progression_link = true
		else 
			@need_new_progression_link = false
		end

		is_user_member = Team.joins(:members).where(members: {team_id: @team_id}).where(members: {user_id: current_user.id})
		
		## ensuring that the page viewer is a member of the team. Probably a better way to do this site wide. 
		if is_user_member.size > 0 || param_play.user_id == current_user.id
			@member = Member.where(team_id: @team_id, user_id: current_user.id).take
			@play = param_play
			@progressions = Progression.where(play_id: @play.id).order(:index)
			Plays::UpdatePlayViewedService.new({play_id: @play.id, member_id: @member.id}).call
		else
			redirect_to root_path
		end	
	end

	def update_name
		play_id = params[:play_id]
		play = Play.find_by_id(play_id)
		play_name = params[:play_name]
		play.update(name: play_name)
	end
	
	def update
		puts "updating progression"
		play_id = params[:id]
		team_id = params[:team_id]
		play = Play.find_by_id(play_id)
		play_name = params[:play_name]
		play.update(name: play_name)
		raw_data = params[:progressions_data]
		raw_data.each do |data|
			data_cluster = data[1]
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
		
	end

	def soft_delete
		play = Play.find_by_id(params[:play_id])
		play.update(deleted_flag: true)
		progression = Progression.where(play_id: play.id)
		progression_img = url_for(progression[0].play_image)
		render :json => {play_id: play.id, progression_img: progression_img, play_name: play.name}
	end

	def recover_all
		team_id = params[:team_id]
		plays = Play.joins(:team_plays).select("team_plays.team_id as team_id, plays.*").where( "team_plays.team_id"=>params[:team_id], "plays.deleted_flag" => true)
		render_content = []
		plays.each do |play|
			json = Plays::RecoverPlayService.new({
				play_id: play.id
			}).call
			json[:progression_img] = url_for(json[:progression_img])
			render_content.push(json)
		end
		render :json => {content: render_content}
	end

	def recover
		json = Plays::RecoverPlayService.new({
			play_id: params[:play_id]
		}).call
		json[:progression_img] = url_for(json[:progression_img])
		render :json => json
	end

	def destroy_all
		team_id = params[:team_id]
		plays = Play.joins(:team_plays).select("team_plays.team_id as team_id, plays.*").where( "team_plays.team_id"=>params[:team_id], "plays.deleted_flag" => true)
		plays.each do |play|
			Plays::DeletePlayService.new({
				play_id: play.id
			}).call
		end
	end

	def destroy
		Plays::DeletePlayService.new({
			play_id: params[:id]
		}).call

	end

	def demo
	end

end
