class TeamsController < ApplicationController
	
	def index
	end

	def show
		##TruncateStatsService.new().call

		##InsertStatDescriptionsService.new().call()

		@non_user_members = nil
		@joined_team = params[:joined_team]
		param_team = Team.find_by_id(params[:id])
		user_members = Member.where(user_id: current_user.id) ## gets all members
		if params[:joined_team]
			@non_user_members = Member.where(team_id: params[:id], user_id: nil)
			@team = param_team
		else
			user_teams = []
			user_members.each do |member|
				user_teams.push(Team.find(member.team_id))  ## accumulates teams belonging to user
			end
			user_teams.each do |userteam|
				@team = param_team if param_team == userteam
			end
		end
		@current_member = user_members.select{|member| member.team_id == @team.id}.first
		
		if @team.nil?
			redirect_to root_path 
		else	
			@posts = Post.where(team_id: @team.id)
		end			
	end

	def new
		@team = Team.new
		@new_member = Member.new

		@team_stat = TeamStat.new()
		## stats that user has to collect in order for the app to perform its basic functions
		@default_collectable = StatList.where(default_stat: true, collectable: true)

		## stats the user may collect but arent required
		@non_default_collectable = StatList.where(default_stat: false, collectable: true)

		@default_basic = StatList.where(default_stat: true, rankable: true, advanced: false).sort_by{|stat| stat.id}

		## basic stats that the application automatically collects based on the default stats
		@default_application_basic = StatList.where(default_stat: true, collectable: false, advanced: false)

		##advanced stats the application automatically collects based on the default stats
		@default_indiv_advanced = StatList.where(default_stat: true, advanced: true)

		## should be nil
		@default_team_advanced = StatList.where(default_stat: true, advanced: true, team_stat: true)

		## advanced stats the application may collect depending on non default stats collected
		@non_default_indiv_advanced = StatList.where(advanced: true, team_stat: false, default_stat: false)

		## advanced stats the application may collect depending on non default stats collected
		@non_default_team_advanced = StatList.where(advanced: true, team_stat: true, default_stat: false)

		@advanced_stats = AdvStatDependenciesService.new({adv_stats: @non_default_indiv_advanced}).call

		@team_advanced_stats = TeamAdvStatDependenciesService.new({adv_stats: @non_default_team_advanced}).call

		## advanced team stats the application may collect depending on non default stats collected
		@team_advanced = StatList.where(advanced: true, team_stat: true)
	end

	def create
		@team = Team.create({
			name: params[:team_name],
			username: params[:username],
			password: params[:password],
			minutes_p_q: params[:minutes_p_q],
		})
		members = params[:players]

		members.each do |new_member|
			member = Member.create({
				nickname: new_member,
				team_id: @team.id,
				season_minutes: 0,
				games_played: 0,
			})
			Assignment.create({
				member_id: member.id,
				role_id: 1
			})
		end
		## is_player = params[:isPlayer]
		@coach = Member.create({
			nickname: current_user.name,
			team_id: @team.id,
			user_id: current_user.id,
		})

		## Coach
		Assignment.create({
			member_id: @coach.id,
			role_id: 2
		})
		## Team owner
		Assignment.create({
			member_id: @coach.id,
			role_id: 4
		})

		@team_stats = params[:team_stats]
		@team_stats.each do |stat_id|
			@team_stat = TeamStat.new(
				stat_list_id: stat_id,
				team_id: @team.id,
				show: true,
			)
			@team_stat.save
		end

		redirect_to team_path(@team.id)
	end	

	def join

		roles = params[:member_type]
		team_username = params[:username]
		team_password = params[:password]
		
		## TODO: UPDATE ROLES
		team_id = JoinTeamService.new({
			roles: roles,
			team_username: team_username,
			team_password: team_password,
			current_user: current_user,
			root_path: root_path,
		}).call

		redirect_path = root_path


		if team_id 
			redirect_path = team_path(team_id, joined_team: true)
		end


		## eventually redirect to a place depending on if JoinTeamService returns a value
		redirect_to redirect_path
	end

	def join_member
		id_to_join = params[:member_id]
		member = Member.find_by_id(id_to_join)
		member.user_id = current_user.id 
		member.save
	end

	private

	def team_params
		params.require(:team).permit(:name, :username, :password, :primary_color, :secondary_color)                  
	end

end
