class TeamsController < ApplicationController
	
	def index
	end

	##SERVICE maybe
	def show
		user_teams = []
		user_members = Member.where(user_id: current_user.id) ## gets all members
		user_members.each do |member|
			user_teams.push(Team.find(member.team_id))  ## accumulates teams belonging to user
		end

		param_team = Team.find_by_id(params[:id])
		user_teams.each do |userteam|
			@team = param_team if param_team == userteam
		end

		if @team.nil?
			redirect_to root_path 
		else	
			@current_member = user_members.select{|member| member.team_id == @team.id}.first
			@posts = Post.where(team_id: @team.id)
			@admin_status = @current_member.isAdmin
		end			
	end

	def new
		@team = Team.new
		@new_member = Member.new
	end

	def create
		@team = Team.new(team_params)
		@team.save
		## is_player = params[:isPlayer]
		@new_member = Member.new(
			##change nickname to view parameter
			nickname: current_user.name,
			team_id: @team.id,
			user_id: current_user.id,
			isAdmin: true,
			isCreator: true,
			)
		@new_member.save
		redirect_to root_path
	end	

	def join
		member_type = params[:member_type]
		team_username = params[:username]
		team_password = params[:password]

		JoinTeamService.new({
			member_type: member_type,
			team_username: team_username,
			team_password: team_password,
			current_user: current_user,
			root_path: root_path,
		}).call

		## eventually redirect to a place depending on if JoinTeamService returns a value
		redirect_to root_path
	end


	private

	def team_params
		params.require(:team).permit(:name, :username, :password, :primary_color, :secondary_color)                  
	end

end
