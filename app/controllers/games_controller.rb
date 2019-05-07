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
		@team = Team.find_by_id(params[:team_id])
		@game = Game.find_by_id(params[:id])
		@players = Member.where(team_id: params[:team_id], isPlayer: true)
		@opponent = Opponent.where(team_id: @team.id, game_id: @game.id).take
		@basic_stats = []
		basic_team_stats = TeamStat.where(team_id: params[:team_id]).joins(:stat_list).where('stat_lists.advanced' => false, 'stat_lists.team_stat' =>false, 'stat_lists.granular' => true);
		basic_team_stats.each do |stat|
			@basic_stats.push(StatList.find_by_id(stat.stat_list_id))
		end
		@stat_table_columns = StatTableColumnsService.new({
			stats: @basic_stats
		}).call
		@player_stats_unsorted = Stat.select("*").joins(:stat_list).where(game_id: @game.id)
		@player_stats = @player_stats_unsorted.sort_by{|e| e.member_id}
		@team_stats = StatTotal.select("*").joins(:stat_list).where(team_id: params[:team_id], game_id: @game.id, is_opponent: false)
		@opponent_stats = StatTotal.select("*").joins(:stat_list).where(team_id: params[:team_id], game_id: @game.id, is_opponent: true)
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
		basic_team_stats = TeamStat.where(team_id: params[:team_id]).joins(:stat_list).where('stat_lists.advanced' => false, 'stat_lists.team_stat' =>false, 'stat_lists.granular' => true);
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
		player_stats = params[:player_stats]
		team_stats = params[:team_stats]
		opponent_stats = params[:opponent_stats]
		game_id = params[:id]
		team_id = params[:team_id]
		
		SubmitGameModeService.new({
			player_stats: player_stats,
			team_stats: team_stats,
			opponent_stats: opponent_stats,
			game_id: game_id,
			team_id: team_id,
		}).call

		redirect_to team_game_path(team_id, game_id)
	end
end
