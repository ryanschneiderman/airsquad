class PlaysController < ApplicationController

	def index
		##params[:team_id]
		if params[:team_id]
			cookies[:team_id] = params[:team_id] 
			@team_id = params[:team_id]
			@plays = Play.joins(:team_plays).where(team_plays: {team_id: params[:team_id]})
		else
			@team_id = nil
			cookies[:team_id] = nil
			@plays = Play.where(user_id: current_user.id)
		end	
	end

	def new
		@play = Play.new
		@team_id = cookies[:team_id]
	end	
	
	##service
	def create
		play_name = params[:play][:name]
		is_offense = params[:play][:offense_defense]
		is_halfcourt = params[:play][:halfcourt_fullcourt]
		

		@play = Play.new(
			name: play_name,
			offense_defense: is_offense,
			halfcourt_fullcourt: is_halfcourt,
			user_id: current_user.id,
			num_progressions: 0,
		)
		@play.save
		if params[:play][:team_id]
			@team_play = TeamPlay.new(play_id: @play.id, team_id: params[:play][:team_id])
			@team_play.save
		end

		redirect_to play_path(@play.id)
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
		
		if is_user_member.size > 0 || param_play.user_id == current_user.id
			@play = param_play
			@progressions = Progression.where(play_id: @play.id).order(:index)
		else
			redirect_to root_path
		end	
	end

	def destroy
		play = Play.find_by_id(params[:id])
		if cookies[:team_id] != "" 
			team_play = TeamPlay.where(play_id: params[:id], team_id: cookies[:team_id]).first
			team_play.destroy
			redirect_path = team_plays_path(cookies[:team_id])
		else
			progressions = Progression.where(play_id: play.id).each do |progression|
				progression.destroy
			end
			play.destroy
			redirect_path = plays_path
		end
		redirect_to redirect_path
	end

end
