class StatsController < ApplicationController

	def index
		@team = Team.find_by_id(params[:team_id])
		@players = Member.where(team_id: params[:team_id], isPlayer: true)
		@opponent = nil

		@stat_table_columns = Stats::BasicStatService.new({
			team_id: params[:team_id]
		}).call

		@adv_stat_table_columns = Stats::AdvancedStatListService.new({
			team_id: params[:team_id]
		}).call

		@team_adv_stat_table_columns = Stats::TeamAdvancedStatListService.new({
			team_id: params[:team_id]
		}).call


		@player_stats_unsorted = SeasonStat.select("*").joins(:stat_list).select("*").joins(:member).where('members.team_id' => @team.id)
		@player_stats = @player_stats_unsorted.sort_by{|e| [e.member_id, e.stat_list_id]}

		@team_stats = TeamSeasonStat.select("*").joins(:stat_list).where(team_id: params[:team_id], is_opponent: false)
		@opponent_stats = TeamSeasonStat.select("*").joins(:stat_list).where(team_id: params[:team_id], is_opponent: true)

		@shot_chart_data = StatGranule.select("*").joins(:member).where('members.team_id' => @team.id).where("stat_list_id IN (?)", [1,2])

		@shot_chart_data.each do |shot|
			puts shot.metadata
		end

		@advanced_stats = SeasonAdvancedStat.select("*").joins(:stat_list, :member).where('members.team_id' => @team.id).sort_by{|e| e.member_id}

		@team_advanced_stats = SeasonTeamAdvStat.select("*").joins(:stat_list, :team).where('teams.id' => @team.id)

		
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
