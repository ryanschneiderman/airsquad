require 'json'

class GamesController < ApplicationController
	def index
		@curr_member =  Assignment.joins(:role).joins(:member).select("roles.name as role_name, members.*").where("members.user_id" => current_user.id, "members.team_id" => params[:team_id])
		@gm_permission = false
		@curr_member.each do |member_obj|
			if member_obj.role_name == "Admin" || member_obj.role_name == "Manager"
				@gm_permission = true
			end
		end
		@team_id = params[:team_id]
		@games = Game.where(team_id: @team_id)
		@game_events = ScheduleEvent.joins(:game).select("games.id as game_id, games.played as played, schedule_events.*").where("schedule_events.team_id" => @team_id)
		@practice_events = ScheduleEvent.joins(:practice).select("practices.id as practice_id, practices.is_scrimmage as is_scrimmage, schedule_events.*").where("schedule_events.team_id" => @team_id)
		@schedule_events = ScheduleEvent.where("schedule_events.team_id" => @team_id)
		
		members = Member.where(team_id: @team_id)
	end 
	
	def new
		@game = Game.new
		@team_id = params[:team_id]
		puts @new_game
	end

	def create
		opponent = params[:opponent]

		team_id = params[:team_id]
		date = params[:date]
		time = params[:time]
		place = params[:location]

		schedule_event = ScheduleEvent.create(
			date: date,
			time: time,
			place: place,
			name: opponent,
			team_id: team_id,
		)

		game = Game.new(team_id: team_id, played: false, schedule_event_id: schedule_event.id)
		game.save

		opponent = Opponent.new(name: opponent, game_id: game.id, team_id: team_id)
		opponent.save
		game.opponent_id = opponent.id
		game.save
		redirect_to team_games_path(team_id)
	end

	def show
		
		@team = Team.find_by_id(params[:team_id])
		@game = Game.find_by_id(params[:id])
		@played = @game.played

		@curr_member =  Assignment.joins(:role).joins(:member).select("roles.name as role_name, members.*").where("members.user_id" => current_user.id, "members.team_id" => params[:team_id])
		@gm_permission = false
		@curr_member.each do |member_obj|
			if member_obj.role_name == "Admin" || member_obj.role_name == "Manager"
				@gm_permission = true
			end
		end

		@players = Assignment.joins(:role).joins(:member).select("roles.name as name, members.*").where("members.team_id" => @team.id, "roles.id" => 1)
		@players.each do |player|
			puts "player name :" + player.nickname
		end

		@opponent = Opponent.where(team_id: @team.id, game_id: @game.id).take
		@opponent_name = @opponent.name

		@stat_table_columns = Stats::BasicStatService.new({
			team_id: params[:team_id]
		}).call

		@adv_stat_table_columns = Stats::AdvancedStatListService.new({
			team_id: params[:team_id]
		}).call

		@team_adv_stat_table_columns = Stats::TeamAdvancedStatListService.new({
			team_id: params[:team_id]
		}).call
		@per_minutes = @team.minutes_p_q * 3

		@player_stats = Stat.select("*").joins(:stat_list).select("*").joins(:member).where(game_id: @game.id).sort_by{|e| [e.member_id, e.stat_list_id]}

		@team_stats = StatTotal.select("*").joins(:stat_list).where(team_id: params[:team_id], game_id: @game.id, is_opponent: false)

		@opponent_stats = StatTotal.select("*").joins(:stat_list).where(team_id: params[:team_id], game_id: @game.id, is_opponent: true)

		@shot_chart_data = StatGranule.select("*").joins(:member).where(game_id: @game.id).where("stat_list_id IN (?)", [1,2])

		@advanced_stats = AdvancedStat.select("*").joins(:stat_list).where(game_id: @game.id).sort_by{|e| [e.member_id, e.stat_list_id]}

		@team_advanced_stats = TeamAdvancedStat.select("*").joins(:stat_list).select("*").where(game_id: @game.id)

		@players = Stats::SortStatService.new({
			game_id: @game.id
		}).call

		@team_stat_table_columns = Stats::BasicStatService.new({
			team_id: params[:team_id]
		}).call

		@team_stat_table_columns.delete_if{|h| h[:stat_name] == "Minutes"}
	end

	def practice_mode
		@team_id = params[:team_id]
		@team = Team.find_by_id(@team_id)
		@players = Assignment.joins(:role).joins(:member).select("roles.name as name, members.*").where("members.team_id" => @team_id, "roles.id" => 1)
		collection_stat_list = []
		@basic_stats = []
		collection_team_stats = TeamStat.where(team_id: params[:team_id]).joins(:stat_list).where('stat_lists.collectable' => true);
		basic_team_stats = TeamStat.where(team_id: params[:team_id]).joins(:stat_list).where('stat_lists.advanced' => false, 'stat_lists.team_stat' =>false, 'stat_lists.is_percent' => false);
		collection_team_stats.each do |stat|
			collection_stat_list.push(StatList.find_by_id(stat.stat_list_id))
		end

		@collection_stats = Stats::CollectableStatsService.new({
			stats: collection_stat_list
		}).call

		basic_team_stats.each do |stat|
			@basic_stats.push(StatList.find_by_id(stat.stat_list_id))
		end

		## return an array which has the fields that we will want to display in the stat table, and their corresponding ordering number.
		@stat_table_columns = Stats::StatTableColumnsService.new({
			stats: @basic_stats,
			is_advanced: false
		}).call
	end

	def scrimmage_mode
		@team_id = params[:team_id]
		@team = Team.find_by_id(@team_id)
		@minutes_p_q = @team.minutes_p_q
		@players = Assignment.joins(:role).joins(:member).select("roles.name as name, members.*").where("members.team_id" => @team_id, "roles.id" => 1)
		collection_stat_list = []
		@basic_stats = []
		collection_team_stats = TeamStat.where(team_id: params[:team_id]).joins(:stat_list).where('stat_lists.collectable' => true);
		basic_team_stats = TeamStat.where(team_id: params[:team_id]).joins(:stat_list).where('stat_lists.advanced' => false, 'stat_lists.team_stat' =>false, 'stat_lists.is_percent' => false);
		collection_team_stats.each do |stat|
			collection_stat_list.push(StatList.find_by_id(stat.stat_list_id))
		end

		@collection_stats = Stats::CollectableStatsService.new({
			stats: collection_stat_list
		}).call

		basic_team_stats.each do |stat|
			@basic_stats.push(StatList.find_by_id(stat.stat_list_id))
		end

		## return an array which has the fields that we will want to display in the stat table, and their corresponding ordering number.
		@stat_table_columns = Stats::StatTableColumnsService.new({
			stats: @basic_stats,
			is_advanced: false
		}).call
	end

	def scrimmage_mode_submit
		player_stats = params[:player_stats]
		team_stats = params[:team_stats]
		opponent_stats = params[:opponent_stats]
		team_id = params[:team_id]
		today = Date.today

		schedule_event = ScheduleEvent.create(
			date: today,
			team_id: team_id,
		)

		practice = Practice.create(
			team_id: team_id,
			schedule_event_id: schedule_event.id,
			is_scrimmage: true,
		)


		SubmitPracticeModeService.new({
			player_stats: player_stats,
			team_stats: team_stats,
			opponent_stas: opponent_stats,
			practice_id: practice.id,
		}).call

		redirect_to team_practice_path(team_id, practice.id)
	end

	def game_mode
		@game_id = params[:id]
		game = Game.find_by_id(@game_id)
		@game_state = game.game_state
		@team_id = params[:team_id]
		@team = Team.find_by_id(@team_id)
		@players = Assignment.joins(:role).joins(:member).select("roles.name as name, members.*").where("members.team_id" => @team_id, "roles.id" => 1)
		@opponent = Opponent.where(game_id: @game_id).take
		team_stats = TeamStat.where(team_id: params[:team_id])
		@minutes_p_q = @team.minutes_p_q


		collection_stat_list = []
		@basic_stats = []
		collection_team_stats = TeamStat.where(team_id: params[:team_id]).joins(:stat_list).where('stat_lists.collectable' => true);
		basic_team_stats = TeamStat.where(team_id: params[:team_id]).joins(:stat_list).where('stat_lists.advanced' => false, 'stat_lists.team_stat' =>false, 'stat_lists.is_percent' => false);
		collection_team_stats.each do |stat|
			collection_stat_list.push(StatList.find_by_id(stat.stat_list_id))
		end

		@collection_stats = Stats::CollectableStatsService.new({
			stats: collection_stat_list
		}).call

		basic_team_stats.each do |stat|
			@basic_stats.push(StatList.find_by_id(stat.stat_list_id))
		end

		## return an array which has the fields that we will want to display in the stat table, and their corresponding ordering number.
		@stat_table_columns = Stats::StatTableColumnsService.new({
			stats: @basic_stats,
			is_advanced: false
		}).call
	end

	def game_state_update
		game = Game.find_by_id(params[:id])
	  	game.update_attributes(:game_state => params[:game_state])
	  	game.save
	end

	## service
	def game_mode_submit
		player_stats = params[:player_stats]
		team_stats = params[:team_stats]
		opponent_stats = params[:opponent_stats]
		lineup_stats = params[:lineup_stats]
		game_id = params[:id]
		team_id = params[:team_id]
		team = Team.find_by_id(team_id)
		game = Game.find_by_id(game_id)
		
		SubmitGameModeService.new({
			player_stats: player_stats,
			team_stats: team_stats,
			opponent_stats: opponent_stats,
			lineup_stats: lineup_stats,
			game_id: game_id,
			team_id: team_id,
			minutes_p_q: team.minutes_p_q
		}).call

		Stats::StatRankingsService.new({
			team_id: team_id,
			is_lineup: false,
		}).call
=begin
		Stats::StatRankingsService.new({
			team_id: team_id,
			is_lineup: true,
		}).call
=end

		game.update(played: true)

		redirect_to team_game_path(team_id, game_id)
	end
end
