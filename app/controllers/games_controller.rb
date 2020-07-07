require 'json'

class GamesController < ApplicationController
	after_action only: [:show] do
	  stat_ranking(@team_id, @curr_season_id)
	end

	def index
		team_id = params[:team_id]
		gon.team_id = team_id
		curr_season = Season.where(team_id: team_id, year2: Date.current.year).take
		if curr_season.nil?
			curr_season = Season.where(team_id: team_id, year1: Date.current.year).take
		end

		@curr_member =  Member.where(user_id: current_user.id, season_id: curr_season.id, team_id: team_id).take

		@schedule_edit_permission = @curr_member.permissions["schedule_edit"]
		gon.schedule_edit_permission = @schedule_edit_permission
		@schedule_view_permission = @curr_member.permissions["schedule_view"]

		# @gm_permission = false
		# if(@curr_member.permissions[:games_edit])
		# 	@gm_permission = true
		# end
		puts "PRINTING CURR SEASON!!!!!!"
		puts curr_season.id
		@games = Game.where(team_id: team_id, season_id: curr_season.id)
		@games.each do |game|
			puts "printing game id!"
			puts game.id
		end
		@game_events = ScheduleEvent.joins(:game).select("games.id as game_id, games.played as played, schedule_events.*").where("schedule_events.team_id" => team_id, "games.season_id" => curr_season.id)
		@game_events.each do |game_event|
			puts game_event.time
		end
		gon.game_events = @game_events
		@practice_events = ScheduleEvent.joins(:practice).select("practices.id as practice_id, practices.is_scrimmage as is_scrimmage, schedule_events.*").where("schedule_events.team_id" => team_id)
		gon.practice_events = @practice_events
		@schedule_events = ScheduleEvent.where("schedule_events.team_id" => team_id)
		
		# members = Member.where(team_id: @team_id)
	end 
	
	def new
		@game = Game.new
		@team_id = params[:team_id]
	end

	def create
		opponent = params[:opponent]

		team_id = params[:team_id]
		date = params[:date]
		time = params[:time]
		place = params[:location]

		curr_season = Season.where(team_id: team_id, year2: Date.current.year).take
		if curr_season.nil?
			curr_season = Season.where(team_id: team_id, year1: Date.current.year).take
		end

		member = Member.where(user_id: current_user.id, team_id: team_id, season_id: curr_season.id).take

		schedule_event = ScheduleEvent.create(
			date: date,
			time: time,
			place: place,
			name: opponent,
			team_id: team_id,
		)

		game = Game.new(team_id: team_id, played: false, schedule_event_id: schedule_event.id, season_id: curr_season.id)
		game.save

		opponent = Opponent.new(name: opponent, game_id: game.id, team_id: team_id)
		opponent.save
		game.opponent_id = opponent.id
		game.save
		redirect_to team_games_path(team_id)

		notif = Notification.create(
			content: "Game scheduled against " + opponent.name + " @ " + place,
			team_id: team_id,
			notif_type_type: "Game",
			notif_type_id: game.id,
			notif_kind: "created"
		)

		members = Member.where(team_id: team_id, season_id: curr_season.id)
		members.each do |team_member|
			if team_member.id != member.id
				MemberNotif.create(
					member_id: team_member.id,
					notification_id: notif.id,
					viewed: false,
					read: false,
				)
			else
				MemberNotif.create(
					member_id: team_member.id,
					notification_id: notif.id,
					viewed: true,
					read: true,
				)
			end
		end

	end

	def show
		team_id = params[:team_id]
		@team = Team.find_by_id(params[:team_id])
		@game = Game.find_by_id(params[:id])
		@played = @game.played
		@team_id = team_id

		@team_name = @team.name

		curr_season = Season.where(team_id: team_id, year2: Date.current.year).take
		if curr_season.nil?
			curr_season = Season.where(team_id: team_id, year1: Date.current.year).take
		end

		@curr_season_id = curr_season.id

		@curr_member =   Member.where(user_id: current_user.id, season_id: curr_season.id, team_id: team_id).take

		@schedule_edit_permission = @curr_member.permissions["schedule_edit"]
		@schedule_view_permission = @curr_member.permissions["schedule_view"]

		@per_minutes = @team.num_periods * @team.period_length / 3

		@players = Member.where(season_id: curr_season.id, team_id: team_id, is_player: true)

		@opponent = Opponent.where(team_id: @team.id, game_id: @game.id).take
		@opponent_name = @opponent.name

		@stat_table_columns = Stats::BasicStatService.new({
			team_id: params[:team_id]
		}).call

		@adv_stat_table_columns = Stats::Advanced::AdvancedStatListService.new({
			team_id: params[:team_id]
		}).call

		@team_adv_stat_table_columns = Stats::Advanced::TeamAdvancedStatListService.new({
			team_id: params[:team_id]
		}).call

		@per_minutes = @team.num_periods * @team.period_length / 3

		
		@player_stats = []
		player_stats_ungrouped = Stat.joins(:stat_list, :member).select("stat_lists.stat as stat, members.nickname as nickname, stat_lists.display_priority as display_priority, stats.*").where('members.team_id' => @team.id, "stats.season_id" => curr_season.id).sort_by{|e| [e.member_id, e.stat_list_id]}
		
		player_stats_ungrouped.group_by(&:member_id).each do |member_id, stats|
			@player_stats.push({member_id: member_id, stats: stats, nickname: stats[0].nickname, games_played: 1})
		end

		@team_stats = StatTotal.select("*").joins(:stat_list).where(team_id: params[:team_id], game_id: @game.id, is_opponent: false, season_id: curr_season.id)

		@opponent_stats = StatTotal.select("*").joins(:stat_list).where(team_id: params[:team_id], game_id: @game.id, is_opponent: true, season_id: curr_season.id)

		@shot_chart_data = []
		shot_chart_data_ungrouped = StatGranule.joins(:member).select("stat_granules.*, members.*").where("stat_granules.game_id" => @game.id, "stat_granules.stat_list_id"=> [1,2])

		shot_chart_data_ungrouped.group_by(&:member_id).each do |member_id, data|
			@shot_chart_data.push({member_id: member_id, data: data, name: data[0].nickname})
		end

		opponent_shot_chart_data = OpponentGranule.where("opponent_granules.game_id" => @game.id, "opponent_granules.stat_list_id"=> [1,2])

		#@shot_chart_data = StatGranule.select("*").joins(:member).where(game_id: @game.id).where("stat_granules.season_id"=> curr_season.id, "stat_granules.stat_list_id"=> [1,2])

		@advanced_stats = []
		advanced_stats_ungrouped = AdvancedStat.joins(:stat_list, :member).select("stat_lists.stat as stat, members.nickname as nickname, stat_lists.stat_description as stat_description, stat_lists.display_priority as display_priority, advanced_stats.*").where('members.team_id' => @team.id, "advanced_stats.season_id" => curr_season.id).sort_by{|e| [e.member_id, e.stat_list_id]}
		advanced_stats_ungrouped.group_by(&:member_id).each do |member_id, stats|
			@advanced_stats.push({member_id: member_id, stats: stats, nickname: stats[0].nickname})
		end

		#@advanced_stats = AdvancedStat.select("*").joins(:stat_list).where(game_id: @game.id, season_id: curr_season.id).sort_by{|e| [e.member_id, e.stat_list_id]}


		@team_advanced_stats = TeamAdvancedStat.select("*").joins(:stat_list).select("*").where(game_id: @game.id, season_id: curr_season.id)

		@players = Stats::SortStatService.new({
			game_id: @game.id,
			season_id: curr_season.id
		}).call

		@team_stat_table_columns = Stats::BasicStatService.new({
			team_id: params[:team_id]
		}).call

		@team_stat_table_columns.delete_if{|h| h[:stat_name] == "Minutes"}

		gon.season_id = curr_season.id
		gon.team_name = @team.name
		gon.team_id = team_id
		gon.num_players = @players.length
		gon.minutes_factor = @per_minutes
		gon.stat_table_columns = @stat_table_columns
		gon.adv_stat_table_columns = @adv_stat_table_columns
		gon.team_adv_stat_table_columns = @team_adv_stat_table_columns
		gon.player_stats = @player_stats
		gon.advanced_stats = @advanced_stats
		gon.team_stats= @team_stats
		gon.opponent_stats = @opponent_stats
		gon.team_advanced_stats = @team_advanced_stats
		gon.shot_chart_data = @shot_chart_data
		gon.opponent_shot_chart_data = opponent_shot_chart_data
		gon.opponent_name = @opponent_name

	end

	def practice_mode
		@team_id = params[:team_id]
		@team = Team.find_by_id(@team_id)

		curr_season = Season.where(team_id: @team_id, year2: Date.current.year)
		if curr_season.nil?
			curr_season = Season.where(team_id: @team_id, year1: Date.current.year)
		end

		@players = Member.where(season_id: curr_season.id, team_id: team_id, is_player: true)

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
		@per_minutes = @team.num_periods * @team.period_length / 3

		curr_season = Season.where(team_id: @team_id, year2: Date.current.year)
		if curr_season.nil?
			curr_season = Season.where(team_id: @team_id, year1: Date.current.year)
		end

		@players = Member.where(season_id: curr_season.id, team_id: team_id, is_player: true)
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

		curr_season = Season.where(team_id: team_id, year2: Date.current.year)
		if curr_season.nil?
			curr_season = Season.where(team_id: team_id, year1: Date.current.year)
		end

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
			season_id: curr_season.id
		}).call

		redirect_to team_practice_path(team_id, practice.id)
	end

	def game_mode
		@game_id = params[:id]
		game = Game.find_by_id(@game_id)
		@game_state = game.game_state
		team_id = params[:team_id]
		@team = Team.find_by_id(team_id)
		gon.game_state = @game_state.to_json.html_safe
		gon.game_id = @game_id
		gon.team_id = team_id
		gon.team_name = @team.name
		
		

		curr_season = Season.where(team_id: team_id, year2: Date.current.year).take
		if curr_season.nil?
			curr_season = Season.where(team_id: team_id, year1: Date.current.year).take
		end

		curr_member =  Member.where(user_id: current_user.id, season_id: curr_season.id, team_id: team_id).take
		gon.current_member = curr_member
		gon.current_user = current_user


		@players = Member.where(season_id: curr_season.id, team_id: team_id, is_player: true)
		gon.players = @players

		@opponent = Opponent.where(game_id: @game_id).take
		gon.opponent = @opponent
		team_stats = TeamStat.where(team_id: params[:team_id])
		@per_minutes = @team.period_length 
		gon.num_periods = @team.num_periods
		gon.period_length = @team.period_length


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

		gon.collection_stats = @collection_stats

		basic_team_stats.each do |stat|
			@basic_stats.push(StatList.find_by_id(stat.stat_list_id))
		end
		gon.basic_stats = @basic_stats

		## return an array which has the fields that we will want to display in the stat table, and their corresponding ordering number.
		@stat_table_columns = Stats::StatTableColumnsService.new({
			stats: @basic_stats,
			is_advanced: false
		}).call
		gon.stat_table_columns = @stat_table_columns.reverse!
	end

	def game_state_update
		game = Game.find_by_id(params[:id])
	  	game.update_attributes(:game_state => params[:game_state])
	  	game.save
	end


	## service
	def game_mode_submit
		start = Time.now
		player_stats = params[:player_stats]
		team_stats = params[:team_stats]
		opponent_stats = params[:opponent_stats]
		lineup_stats = params[:lineup_stats]
		game_id = params[:id]
		@team_id = params[:team_id]

		curr_season = Season.where(team_id: @team_id, year2: Date.current.year).take
		if curr_season.nil?
			curr_season = Season.where(team_id: @team_id, year1: Date.current.year).take
		end

		@curr_season_id = curr_season.id


		team = Team.find_by_id(@team_id)
		game = Game.find_by_id(game_id)
		schedule_event = ScheduleEvent.find_by_id(game.schedule_event_id)
		opponent = Opponent.find_by_id(game.opponent_id)
		member = Member.where(user_id: current_user.id, season_id: curr_season.id).take


		if game.played
			Stats::RollbackGameService.new({game_id: game_id, submit: true, team_id: @team_id, season_id: curr_season.id}).call
		end

		SubmitGameModeService.new({
			player_stats: player_stats,
			team_stats: team_stats,
			opponent_stats: opponent_stats,
			lineup_stats: lineup_stats,
			game_id: game_id,
			team_id: @team_id,
			minutes_p_q: team.num_periods * team.period_length / 3,
			season_id: curr_season.id
		}).call

		post = Post.create(
			title: "Game data vs " + opponent.name + " available",
			team_id: @team_id,
			member_id: member.id,
			post_type_type: "Game",
			post_type_id: game_id,
		)

		game.update(played: true)
		game.save

		notif = Notification.create(
			content: "Stats added for game vs. " + opponent.name + " @ " + schedule_event.place,
			team_id: @team_id,
			notif_type_type: "Game",
			notif_type_id: game.id,
			notif_kind: "added"
		)

		members = Member.where(team_id: @team_id)
		members.each do |team_member|
			if team_member.id != member.id
				MemberNotif.create(
					member_id: team_member.id,
					notification_id: notif.id,
					viewed: false,
					read: false,
				)
			else
				MemberNotif.create(
					member_id: team_member.id,
					notification_id: notif.id,
					viewed: true,
					read: true,
				)
			end
		end

		# code to time
		finish = Time.now
		puts "**************************************** EXECUTE TIME ****************************************"
		puts finish-start
		redirect_to team_game_path(@team_id, game_id)


	end

	private

	def stat_ranking(team_id, curr_season_id)
		Stats::GameModeCallbackService.new({
			team_id: team_id,
			curr_season_id: curr_season_id
		}).call
	end
end
