class StatsController < ApplicationController

	def index
		@team_stats = TeamStat.where(team_id: params[:team_id])
		@team_id = params[:team_id]
	end 

	def new
	end

	def create
		value = params[:value]
		stat_list_id = params[:stat_list]
		game_id = params[:game_id]
		member_id = params[:member_id]

		@stat = Stat.new(value: value, stat_list_id: stat_list_id, game_id: game_id, member_id: member_id)
		@stat.save
	end

	def show
	end


end
