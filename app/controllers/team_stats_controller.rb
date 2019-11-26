class TeamStatsController < ApplicationController
	def new 
		@team_id = params[:team_id]
		@team_stat = TeamStat.new()
		## stats that user has to collect in order for the app to perform its basic functions
		@default_collectable = StatList.where(default: true, collectable: true)

		## stats the user may collect but arent required
		@non_default_collectable = StatList.where(default: false, collectable: true)

		## basic stats that the application automatically collects based on the default stats
		@default_application_basic = StatList.where(default: true, collectable: false, advanced: false)

		##advanced stats the application automatically collects based on the default stats
		@default_application_advanced = StatList.where(default: true, collectable: false, advanced: true)

		## advanced stats the application may collect depending on non default stats collected
		@non_default_advanced = StatList.where(advanced: true, team_stat: false, default: false)

		@advanced_stats = AdvStatDependenciesService.new({adv_stats: @non_default_advanced}).call

		## advanced team stats the application may collect depending on non default stats collected
		@team_advanced = StatList.where(advanced: true, team_stat: true)



	end

	def create
		@team_stats = params[:team_stats]
		@team_id = params[:team_id]
		@team_stats.each do |stat_id|
			@team_stat = TeamStat.new(
				stat_list_id: stat_id,
				team_id: @team_id,
				show: true,
			)
			@team_stat.save
		end
		redirect_to team_stats_path
	end

	def edit
		@team_stat = TeamStat.new()
		@stat_list = StatList.all()
	end

	def update
	end

end
