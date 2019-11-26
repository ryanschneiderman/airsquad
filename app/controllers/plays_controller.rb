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
		
		puts @play.name
		progression_str = @play.name + "1.png"
		param_data = params[:play_image]
		image_data = Base64.decode64(param_data['data:image/png;base64,'.length .. -1])
		image = MiniMagick::Image.read(image_data)
		image.format("png")

		progression.play_image.attach(io: StringIO.new(image.to_blob), filename: progression_str, content_type: "image/jpeg")
		progression.save

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
			@progressions.each do |pro|
				#puts pro.play_image.download
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

	def destroy
		play = Play.find_by_id(params[:id])
		team_id = params[:team_id]

		progressions = Progression.where(play_id: play.id).each do |progression|
			progression.destroy
		end
		play.destroy

		redirect_to team_plays_path(team_id)
	end

end
