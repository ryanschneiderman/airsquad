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

	def lineup_explorer
		@team_id = params[:team_id]

		## need season stats for each player
		@def_season_stats = SeasonStat.joins(:stat_list, :member).select("members.games_played as games_played, members.season_minutes as season_minutes, stat_lists.stat as stat, stat_lists.stat_kind as stat_kind, members.nickname as nickname, stat_lists.display_priority as display_priority, season_stats.*").where('members.team_id' => @team_id, 'stat_lists.stat_kind' => 2).sort_by{|e| [e.member_id, e.stat_list_id]}
		@off_season_stats = SeasonStat.joins(:stat_list, :member).select("members.games_played as games_played, members.season_minutes as season_minutes, stat_lists.stat as stat, stat_lists.stat_kind as stat_kind, members.nickname as nickname, stat_lists.display_priority as display_priority, season_stats.*").where('members.team_id' => @team_id, 'stat_lists.stat_kind' => 1).sort_by{|e| [e.member_id, e.stat_list_id]}
		## need advanced stats for each player
		@off_advanced_stats = SeasonAdvancedStat.joins(:stat_list, :member).select("stat_lists.stat as stat, members.nickname as nickname, stat_lists.stat_kind as stat_kind, stat_lists.display_priority as display_priority, season_advanced_stats.*").where('members.team_id' => @team_id, 'stat_lists.stat_kind' => 1).sort_by{|e| [e.member_id, e.stat_list_id]}
		@def_advanced_stats = SeasonAdvancedStat.joins(:stat_list, :member).select("stat_lists.stat as stat, members.nickname as nickname, stat_lists.stat_kind as stat_kind, stat_lists.display_priority as display_priority, season_advanced_stats.*").where('members.team_id' => @team_id, 'stat_lists.stat_kind' => 2).sort_by{|e| [e.member_id, e.stat_list_id]}
		@neut_advanced_stats = SeasonAdvancedStat.joins(:stat_list, :member).select("stat_lists.stat as stat, members.nickname as nickname, stat_lists.stat_kind as stat_kind, stat_lists.display_priority as display_priority, season_advanced_stats.*").where('members.team_id' => @team_id, 'stat_lists.stat_kind' => 3).sort_by{|e| [e.member_id, e.stat_list_id]}
		## add offense/defense stat distinction
		##TODO
		## stat table columns
		@stat_table_columns = Stats::BasicStatService.new({
			team_id: params[:team_id]
		}).call
		@adv_stat_table_columns = Stats::AdvancedStatListService.new({
			team_id: params[:team_id]
		}).call
		## way to calculate ranks in the front end -- this is a big problem. Maybe not actually. This could call for a more elaborate data structure. Let's draw it out. HASH TABLE OR BST
		## QUERY PREVIOUS LINEUPS

		
		@members = Member.where(team_id: @team_id, isPlayer: true);
	end


	private

	def team_params
		params.require(:team).permit(:name, :username, :password, :primary_color, :secondary_color)                  
	end

end
