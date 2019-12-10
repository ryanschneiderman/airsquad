require 'json'

class PracticesController < ApplicationController

	def show
		
		@team = Team.find_by_id(params[:team_id])
		@practice = Practice.find_by_id(params[:id])
		@is_scrimmage = @practice.is_scrimmage
		@per_minutes = @team.minutes_p_q * 3
		if @is_scrimmage
			@page_title = "Scrimmage"
			@opponent_name = "Opponent"
		else
			@page_title = "Practice"
			@opponent_name = "Team 2"
		end


		@players = Assignment.joins(:role).joins(:member).select("roles.name as name, members.*").where("members.team_id" => @team.id, "roles.id" => 1)

		@stat_table_columns = Stats::BasicStatService.new({
			team_id: params[:team_id]
		}).call

		@per_minutes = @team.minutes_p_q * 3

		@player_stats = PracticeStat.select("*").joins(:stat_list).select("*").joins(:member).where(practice_id: @practice.id).sort_by{|e| [e.member_id, e.stat_list_id]}

		@team_stats = PracticeStatTotal.select("*").joins(:stat_list).where(team_id: params[:team_id], practice_id: @practice.id, is_opponent: false)

		@opponent_stats = PracticeStatTotal.select("*").joins(:stat_list).where(team_id: params[:team_id], practice_id: @practice.id, is_opponent: true)

		@shot_chart_data = PracticeStatGranule.select("*").joins(:member).where(practice_id: @practice.id).where("stat_list_id IN (?)", [1,2])



		@players = Stats::SortPracticeStatService.new({
			practice_id: @practice.id
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
		is_scrimmage = params[:is_scrimmage]
		today = Date.today

		schedule_event = ScheduleEvent.create(
			date: today,
			team_id: team_id,
		)

		practice = Practice.new(
			team_id: team_id,
			schedule_event_id: schedule_event.id,
			is_scrimmage: is_scrimmage,
			game_state: nil
		)

		practice.validate!            # => ["cannot be nil"]
		practice.errors.full_messages # => ["name cannot be nil"]

		practice.save


		SubmitPracticeModeService.new({
			player_stats: player_stats,
			team_stats: team_stats,
			opponent_stats: opponent_stats,
			practice_id: practice.id,
			team_id: team_id
		}).call

		redirect_to team_practice_path(team_id, practice.id)
	end

	def practice_mode_submit
		player_stats = params[:player_stats]
		team_stats = params[:team_stats]
		opponent_stats = params[:opponent_stats]
		team_id = params[:team_id]
		today = Date.today

		schedule_event = ScheduleEvent.create(
			date: today,
			team_id: team_id,
		)

		practice = Practice.new(
			team_id: team_id,
			schedule_event_id: schedule_event.id,
			is_scrimmage: false,
			game_state: nil
		)

		practice.validate!            # => ["cannot be nil"]
		practice.errors.full_messages # => ["name cannot be nil"]

		practice.save


		SubmitPracticeModeService.new({
			player_stats: player_stats,
			team_stats: team_stats,
			opponent_stats: opponent_stats,
			practice_id: practice.id,
			team_id: team_id
		}).call

		redirect_to team_practice_path(team_id, practice.id)
	end

end
