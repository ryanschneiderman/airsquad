require 'json'

class GamesController < ApplicationController
	def index
		@team_id = params[:team_id]
		@games = Game.where(team_id: @team_id)
	end 
	
	def new
		@team_id = params[:team_id]
		@game = Game.new()
	end

	def create
		opponent = params[:game][:opponent]
		team_id = params[:game][:team_id]
		date = params[:game][:date]

		game = Game.new(team_id: team_id, date: date)
		game.save

		opponent = Opponent.new(name: opponent, game_id: game.id, team_id: team_id)
		opponent.save
		game.opponent_id = opponent.id
		game.save
		redirect_to team_path(params[:game][:team_id])
	end

	def show
		@team_id = params[:team_id]
		@game = Game.find_by_id(params[:id])

		@makes = []
		@misses = []
		@rebounds = []
		@steals = []
		@blocks = []
		@free_throws = []
		@fouls = []

		@all_stat_granules = StatGranule.where(game_id: params[:id], member_id: !nil)

		@all_stat_granules.each do |granule|
			case granule.stat_list_id
			when 2
				@rebounds.push(granule)
			when 3
				@makes.push(granule)
			when 4
				@misses.push(granule)
			when 5
				@steals.push(granule)
			when 6
				@blocks.push(granule)
			when 7 
				@free_throws.push(granule)
			when 8 
				@fouls.push(granule)
			end
		end
		
	end

	def game_mode
		@game_id = params[:id]
		@team_id = params[:team_id]
		@team = Team.find_by_id(@team_id)
		@players = Member.where(team_id: params[:team_id], isPlayer: true)
		@opponent = Opponent.where(game_id: @game_id).take
		team_stats = TeamStat.where(team_id: params[:team_id])

		@collection_stats = []
		@basic_stats = []
		collection_team_stats = TeamStat.where(team_id: params[:team_id]).joins(:stat_list).where('stat_lists.collectable' => true);
		basic_team_stats = TeamStat.where(team_id: params[:team_id], show: true).joins(:stat_list).where('stat_lists.advanced' => false, 'stat_lists.team_stat' =>false);
		collection_team_stats.each do |stat|
			@collection_stats.push(StatList.find_by_id(stat.stat_list_id))
		end
		basic_team_stats.each do |stat|
			@basic_stats.push(StatList.find_by_id(stat.stat_list_id))
		end

		## return an array which has the fields that we will want to display in the stat table, and their corresponding ordering number.
		@stat_table_columns = StatTableColumnsService.new({
			stats: @basic_stats
		}).call

	end

	## service
	def game_mode_submit
		stats = params[:stats]
		game_id = params[:id]
		team_id = params[:team_id]
		
		SubmitGameModeService.new({
			stats: stats,
			game_id: game_id}).call

		redirect_to team_game_path(team_id, game_id)

		
	end
end
