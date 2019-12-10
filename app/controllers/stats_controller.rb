class StatsController < ApplicationController

	def index
		StatList.where(id: 14).limit(1).update_all(display_priority: 7)
		#InsertStatListsService.new().call
		#Stats::RollbackGameService.new({game_id: 37}).call
		@team = Team.find_by_id(params[:team_id])
		@players = Assignment.joins(:role).joins(:member).select("roles.name as name, members.*").where("members.team_id" => @team.id, "roles.id" => 1)
		@per_minutes = @team.minutes_p_q * 3
		@num_games = Game.where(team_id: params[:team_id], played: true).count
		@opponent_name = "Opponents"

		@stat_table_columns = Stats::BasicStatService.new({
			team_id: params[:team_id]
		}).call

		@adv_stat_table_columns = Stats::AdvancedStatListService.new({
			team_id: params[:team_id]
		}).call

		@team_adv_stat_table_columns = Stats::TeamAdvancedStatListService.new({
			team_id: params[:team_id]
		}).call

		@player_stats = SeasonStat.joins(:stat_list, :member).select("members.games_played as games_played, members.season_minutes as season_minutes, stat_lists.stat as stat, members.nickname as nickname, stat_lists.display_priority as display_priority, season_stats.*").where('members.team_id' => @team.id).sort_by{|e| [e.member_id, e.stat_list_id]}

		@team_stats = TeamSeasonStat.select("*").joins(:stat_list).where(team_id: params[:team_id], is_opponent: false)

		@opponent_stats = TeamSeasonStat.select("*").joins(:stat_list).where(team_id: params[:team_id], is_opponent: true)

		@shot_chart_data = StatGranule.select("*").joins(:member).where('members.team_id' => @team.id).where("stat_list_id IN (?)", [1,2])

		@advanced_stats = SeasonAdvancedStat.joins(:stat_list, :member).select("stat_lists.stat as stat, members.nickname as nickname, stat_lists.stat_description as stat_description, stat_lists.display_priority as display_priority, season_advanced_stats.*").where('members.team_id' => @team.id).sort_by{|e| [e.member_id, e.stat_list_id]}

		@team_advanced_stats = SeasonTeamAdvStat.select("*").joins(:stat_list, :team).where('teams.id' => @team.id)
		@stat_totals = StatTotal.joins(:stat_list).joins(:game => :schedule_event).select("schedule_events.date as date, stat_lists.stat as stat, stat_totals.*").where("stat_lists.team_stat" => false, "stat_totals.team_id" => @team.id, "stat_totals.is_opponent" => false, "stat_lists.rankable" => true).sort_by{|e| [e.stat_list_id, e.date]}
		@trend_stat_lists = TeamStat.joins(:stat_list).select("stat_lists.stat as stat, team_stats.*").where("team_stats.team_id" => @team.id, "stat_lists.team_stat" => false, "stat_lists.rankable" => true, "stat_lists.advanced" => false).sort_by{|e| e.stat_list_id}
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
