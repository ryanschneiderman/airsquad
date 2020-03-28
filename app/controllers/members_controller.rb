
## ************* EVENTUALLY MUST USE TEAM STATS ******************

class MembersController < ApplicationController
	def player_profile
		team_id = params[:team_id]
		member_id = params[:member_id]
		@member = Member.find_by_id(member_id)
		minutes_p_q = Team.find_by_id(team_id).minutes_p_q
		@minutes_factor = minutes_p_q * 3
		@players = Assignment.joins(:role).joins(:member).select("roles.name as role_name, members.*").where( "members.team_id" => team_id, "roles.id" => 1)
		@num_players = @players.length

		## TODO: THINK OF A WAY TO ORDER THESE STATS BETTER
		@basic_stats = SeasonStat.joins(:stat_list).select("stat_lists.stat as stat, stat_lists.display_priority as display_priority, season_stats.*").where("season_stats.member_id" => member_id)

		@off_season_stats = SeasonStat.joins(:stat_list).select("stat_lists.stat as stat, stat_lists.stat_kind as stat_kind, season_stats.*").where("stat_lists.rankable" => true, "season_stats.member_id" => member_id, "stat_lists.stat_kind" => 1).sort_by{|e| e.stat_list_id}
		@def_season_stats = SeasonStat.joins(:stat_list).select("stat_lists.stat as stat, stat_lists.stat_kind as stat_kind, season_stats.*").where("stat_lists.rankable" => true, "season_stats.member_id" => member_id, "stat_lists.stat_kind" => 2).sort_by{|e| e.stat_list_id}
		@advanced_stats_pre = SeasonAdvancedStat.joins(:stat_list).select("stat_lists.stat as stat, stat_lists.display_priority as display_priority, stat_lists.stat_description as stat_description, season_advanced_stats.*").where("stat_lists.rankable" => true, "stat_lists.team_stat" => false, "season_advanced_stats.member_id" => member_id)
		@advanced_stats_pre.each do |stat|
			puts stat.stat 
			puts stat.display_priority
		end
		@advanced_stats = SeasonAdvancedStat.joins(:stat_list).select("stat_lists.stat as stat, stat_lists.display_priority as display_priority, stat_lists.stat_description as stat_description, season_advanced_stats.*").where("stat_lists.rankable" => true, "stat_lists.team_stat" => false, "season_advanced_stats.member_id" => member_id).sort_by{|e| e.display_priority}

		@off_advanced_season_stats = SeasonAdvancedStat.joins(:stat_list).select("stat_lists.stat as stat, stat_lists.stat_kind as stat_kind, stat_lists.display_priority as display_priority, season_advanced_stats.*").where("stat_lists.rankable" => true, "stat_lists.team_stat" => false, "season_advanced_stats.member_id" => member_id, "stat_lists.stat_kind" => 1).sort_by{|e| e.display_priority}
		@def_advanced_season_stats = SeasonAdvancedStat.joins(:stat_list).select("stat_lists.stat as stat, stat_lists.stat_kind as stat_kind, stat_lists.display_priority as display_priority, season_advanced_stats.*").where("stat_lists.rankable" => true, "stat_lists.team_stat" => false, "season_advanced_stats.member_id" => member_id, "stat_lists.stat_kind" => 2).sort_by{|e| e.display_priority}
		
		@stat_table_columns = Stats::BasicStatService.new({
			team_id: params[:team_id]
		}).call

		@adv_stat_table_columns = Stats::AdvancedStatListService.new({
			team_id: params[:team_id]
		}).call

		@minutes = Stat.joins(:stat_list).joins(:game => :schedule_event).select("schedule_events.date as date, stat_lists.stat as stat, stats.*").where("stat_lists.id" => 16, "stats.member_id" => member_id).sort_by{|e| e.date}

		@trend_stats =  Stat.joins(:stat_list).joins(:game => :schedule_event).select("schedule_events.date as date, stat_lists.stat as stat, stats.*").where("stats.member_id" => member_id, "stat_lists.rankable" => true).sort_by{|e| [e.stat_list_id, e.date]}
		@trend_stat_lists = TeamStat.joins(:stat_list).select("stat_lists.stat as stat, team_stats.*").where("team_stats.team_id" => team_id, "stat_lists.team_stat" => false, "stat_lists.rankable" => true, "stat_lists.advanced" => false).sort_by{|e| e.stat_list_id}
		@adv_trend_stat_lists = TeamStat.joins(:stat_list).select("stat_lists.stat as stat, team_stats.*").where("team_stats.team_id" => team_id, "stat_lists.team_stat" => false, "stat_lists.rankable" => true, "stat_lists.advanced" => true).sort_by{|e| e.stat_list_id}

		@shot_chart_data = StatGranule.where(member_id: member_id).where("stat_list_id IN (?)", [1,2])
		@adv_trend_stats = AdvancedStat.joins(:stat_list).joins(:game => :schedule_event).select("schedule_events.date as date, stat_lists.stat as stat, advanced_stats.*").where("stat_lists.team_stat" => false, "advanced_stats.member_id" => member_id , "stat_lists.rankable" => true).sort_by{|e| [e.stat_list_id, e.date]}
	end

end
