class TeamStatsController < ApplicationController
	def new 
		@team_stat = TeamStat.new()
		@stat_list = StatList.all()
	end

	def create
		@team_stats = params[:team_stat][:stat_list_id]
		@team_id = params[:team_id]
		@team_stats.each do |stat_id|
			@team_stat = TeamStat.new(
				stat_list_id: stat_id,
				team_id: @team_id
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
