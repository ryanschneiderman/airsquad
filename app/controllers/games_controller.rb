require 'json'

class GamesController < ApplicationController
	def index
		@team_id = params[:team_id]
		@games = Game.where(team_id: @team_id)
	end 
	
	def new
		@game = Game.new
		@team_id = params[:team_id]
		puts @new_game
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
		played = @game.played

		if played 
		else
			render :partial => "game_preview" and return
		end

		@players = Member.where(team_id: params[:team_id], isPlayer: true)
		@opponent = Opponent.where(team_id: @team.id, game_id: @game.id).take

		@stat_table_columns = Stats::BasicStatService.new({
			team_id: params[:team_id]
		}).call

		@adv_stat_table_columns = Stats::AdvancedStatListService.new({
			team_id: params[:team_id]
		}).call

		@team_adv_stat_table_columns = Stats::TeamAdvancedStatListService.new({
			team_id: params[:team_id]
		}).call


		player_stats_unsorted = Stat.select("*").joins(:stat_list).select("*").joins(:member).where(game_id: @game.id)
		@player_stats = player_stats_unsorted.sort_by{|e| [e.member_id, e.stat_list_id]}

		@team_stats = StatTotal.select("*").joins(:stat_list).where(team_id: params[:team_id], game_id: @game.id, is_opponent: false)

		@opponent_stats = StatTotal.select("*").joins(:stat_list).where(team_id: params[:team_id], game_id: @game.id, is_opponent: true)

		@shot_chart_data = StatGranule.select("*").joins(:member).where(game_id: @game.id).where("stat_list_id IN (?)", [1,2])

		@advanced_stats = AdvancedStat.select("*").joins(:stat_list).where(game_id: @game.id).sort_by{|e| e.member_id}
		@advanced_stats = @advanced_stats.sort_by{|e| [e.member_id, e.stat_list_id]}

		@team_advanced_stats = TeamAdvancedStat.select("*").joins(:stat_list).where(game_id: @game.id)

		render file: "games/show_test"
		
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
		@stat_table_columns = Stats::StatTableColumnsService.new({
			stats: @basic_stats,
			is_advanced: false
		}).call

	end

	## service
	def game_mode_submit
		player_stats = params[:player_stats]
		team_stats = params[:team_stats]
		opponent_stats = params[:opponent_stats]
		game_id = params[:id]
		team_id = params[:team_id]
		team = Team.find_by_id(team_id)
		game = Game.find_by_id(game_id)
		game.update(played: true)
		
		SubmitGameModeService.new({
			player_stats: player_stats,
			team_stats: team_stats,
			opponent_stats: opponent_stats,
			game_id: game_id,
			team_id: team_id,
			minutes_p_q: team.minutes_p_q
		}).call

		redirect_to team_game_path(team_id, game_id)
	end
end
