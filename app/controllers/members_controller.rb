
## ************* EVENTUALLY MUST USE TEAM STATS ******************

class MembersController < ApplicationController
	def player_profile
		team_id = params[:team_id]
		member_id = params[:member_id]
		@member = Member.find_by_id(member_id)

		@season_stats = SeasonStat.joins(:stat_list).select("stat_lists.stat as stat, season_stats.*").where("stat_lists.rankable" => true, "season_stats.member_id" => member_id)
		@advanced_season_stats = SeasonAdvancedStat.joins(:stat_list).select("stat_lists.stat as stat, stat_lists.display_priority as display_priority, season_advanced_stats.*").where("stat_lists.rankable" => true, "stat_lists.team_stat" => false, "season_advanced_stats.member_id" => member_id).sort_by{|e| e.display_priority}
		
		@adv_stat_table_columns = Stats::AdvancedStatListService.new({
			team_id: params[:team_id]
		}).call

		@minutes = Stat.joins(:stat_list).joins(:game => :schedule_event).select("schedule_events.date as date, stat_lists.stat as stat, stats.*").where("stat_lists.id" => 16, "stats.member_id" => member_id).sort_by{|e| e.date}

		@trend_stats =  Stat.joins(:stat_list).joins(:game => :schedule_event).select("schedule_events.date as date, stat_lists.stat as stat, stats.*").where("stat_lists.team_stat" => false, "stats.member_id" => member_id, "stat_lists.rankable" => true).sort_by{|e| [e.stat_list_id, e.date]}
		@trend_stat_lists = TeamStat.joins(:stat_list).select("stat_lists.stat as stat, team_stats.*").where("team_stats.team_id" => team_id, "stat_lists.team_stat" => false, "stat_lists.rankable" => true, "stat_lists.advanced" => false).sort_by{|e| e.stat_list_id}
		@adv_trend_stat_lists = TeamStat.joins(:stat_list).select("stat_lists.stat as stat, team_stats.*").where("team_stats.team_id" => team_id, "stat_lists.team_stat" => false, "stat_lists.rankable" => true, "stat_lists.advanced" => true).sort_by{|e| e.stat_list_id}

		@shot_chart_data = StatGranule.where(member_id: member_id).where("stat_list_id IN (?)", [1,2])
		@adv_trend_stats = AdvancedStat.joins(:stat_list).joins(:game => :schedule_event).select("schedule_events.date as date, stat_lists.stat as stat, advanced_stats.*").where("stat_lists.team_stat" => false, "advanced_stats.member_id" => member_id , "stat_lists.rankable" => true).sort_by{|e| [e.stat_list_id, e.date]}
	end
end
