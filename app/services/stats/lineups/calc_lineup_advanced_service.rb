
class Stats::Lineups::CalcLineupAdvancedStatsService

	def initialize(params)
		@lineup_id = params[:lineup_id]
		@team_id = params[:team_id]
		@season_id = params[:season_id]

		@field_goals = LineupStat.where(lineup_id: @lineup_id, is_opponent: false, stat_list_id: 1, season_id: @season_id)
		@field_goal_misses = LineupStat.where(lineup_id: @lineup_id, is_opponent: false, stat_list_id: 2, season_id: @season_id)
		@field_goal_att = @field_goals + @field_goal_misses

		@free_throw_makes = LineupStat.where(lineup_id: @lineup_id, is_opponent: false, stat_list_id: 13, season_id: @season_id)
		@free_throw_misses = LineupStat.where(lineup_id: @lineup_id, is_opponent: false, stat_list_id: 14, season_id: @season_id)
		@free_throw_attempts = @free_throw_makes + @free_throw_misses

		@turnovers = LineupStat.where(lineup_id: @lineup_id, is_opponent: false, stat_list_id: 7, season_id: @season_id)
		@off_reb = LineupStat.where(lineup_id: @lineup_id, is_opponent: false, stat_list_id: 4, season_id: @season_id)
		@def_reb = LineupStat.where(lineup_id: @lineup_id, is_opponent: false, stat_list_id: 5, season_id: @season_id)
		@points = LineupStat.where(lineup_id: @lineup_id, is_opponent: false, stat_list_id: 15, season_id: @season_id)
		@three_point_fg = LineupStat.where(lineup_id: @lineup_id, is_opponent: false, stat_list_id: 11, season_id: @season_id)
		@assists = LineupStat.where(lineup_id: @lineup_id, is_opponent: false, stat_list_id: 3, season_id: @season_id)


		@opp_field_goal_makes = LineupStat.where(lineup_id: @lineup_id, is_opponent: true, stat_list_id: 1, season_id: @season_id)
		@opp_field_goal_misses = LineupStat.where(lineup_id: @lineup_id, is_opponent: true, stat_list_id: 2, season_id: @season_id)
		@opp_field_goal_att = @opp_field_goal_makes + @opp_field_goal_misses

		@opp_free_throw_makes = LineupStat.where(lineup_id: @lineup_id, is_opponent: true, stat_list_id: 13, season_id: @season_id)
		@opp_free_throw_misses = LineupStat.where(lineup_id: @lineup_id, is_opponent: true, stat_list_id: 14, season_id: @season_id)
		@opp_free_throw_att = @opp_free_throw_makes + @opp_free_throw_misses

		@opp_turnovers = LineupStat.where(lineup_id: @lineup_id, is_opponent: true, stat_list_id: 7, season_id: @season_id)
		@opp_off_reb = LineupStat.where(lineup_id: @lineup_id, is_opponent: true, stat_list_id: 4, season_id: @season_id)
		@opp_def_reb = LineupStat.where(lineup_id: @lineup_id, is_opponent: true, stat_list_id: 5, season_id: @season_id)
		@opp_points = LineupStat.where(lineup_id: @lineup_id, is_opponent: true, stat_list_id: 15, season_id: @season_id)


		
	end

	def call
		is_ortg = false
		is_drtg = false
		team_advanced_stats = TeamStat.joins(:stat_list).select("stat_lists.advanced as advanced, team_stats.*").where("stat_lists.advanced" => true, "team_stats.team_id" => @team_id).sort_by{|e| e.stat_list_id}
		if team_advanced_stats.any?{|a| a.stat_list_id == 43}
			possessions()
		end
		team_advanced_stats.each do |stat|
			case stat.stat_list_id
			when 18
				efg_pct()
			when 19
				ts_pct()
			when 30
				offensive_rating()
				is_ortg = true
			when 31
				defensive_rating()
				is_drtg = true
			when 52
				oreb_pct()
			when 34
				dreb_pct()
			when 52
				ast_ratio()
			end
		end

	end

	private 


	def possessions()
		@poss = Stats::Advanced::Team::PossessionsService.new({
			team_field_goal_att:  @field_goal_att,
			team_free_throw_att:  @free_throw_att,
			team_turnovers:  @turnovers,
			team_off_reb: @off_reb
		}).call


		@season_poss = LineupAdvStat.where(stat_list_id: 43, lineup_id: @lineup_id, is_opponent: false, season_id: @season_id).take

		@season_poss.value = @poss
		@season_poss.constituent_stats = {
			"field_goal_att" => @field_goal_att,
			"free_throw_att" => @free_throw_att,
			"turnovers" => @turnovers,
			"off_reb" => @off_reb,
		}
		@season_poss.save
		

		@opp_poss = Stats::Advanced::Team::PossessionsService.new({
			team_field_goal_att:  @opp_field_goal_att,
			team_free_throw_att:  @opp_free_throw_att,
			team_turnovers:  @opp_turnovers,
			team_off_reb: @opp_off_reb
		}).call


		@season_opp_poss = LineupAdvStat.where(stat_list_id: 43, lineup_id: @lineup_id, is_opponent: true, season_id: @season_id).take
		@season_opp_poss.value = @opp_poss
		@season_opp_poss.constituent_stats = {
			"field_goal_att" => @opp_field_goal_att,
			"free_throw_att" => @opp_free_throw_att,
			"turnovers" => @opp_turnovers,
			"off_reb" => @opp_off_reb,
		}
		@season_opp_poss.save
	end

	def offensive_rating()
		@off_rating = Stats::Advanced::Team::OffensiveEfficiencyService.new({
			possessions: @poss,
			team_points: @points
		}).call


		season_off_rtg = LineupAdvStat.where(stat_list_id: 30, lineup_id: @lineup_id, is_opponent: false, season_id: @season_id).take

		season_off_rtg.value = @off_rating
		season_off_rtg.constituent_stats = {
			"possessions" => @poss,
			"points" => @points,
		}
		season_off_rtg.save
	
	end

	def defensive_rating()
		@def_rating = Stats::Advanced::Team::DefensiveEfficiencyService.new({
			opp_possessions: @opp_poss,
			opp_points: @opp_points
		}).call


		season_def_rtg = LineupAdvStat.where(stat_list_id: 31, lineup_id: @lineup_id, is_opponent: false, season_id: @season_id).take

		season_def_rtg.value = @def_rating
		season_def_rtg.constituent_stats = {
			"opp_possessions" => @opp_poss,
			"opp_points" => @opp_points,
		}
		season_def_rtg.save
	end

	def net_rating()
		@net_rating = @off_rating - @def_rating 
	end

	def ast_ratio()
		@ast_ratio = Stats::Advanced::Team::AssistRatioService.new({
			possessions: @poss,
			assists: @assists
		}).call

		season_ast_ratio = LineupAdvStat.where(stat_list_id: 52, lineup_id: @lineup_id, is_opponent: false, season_id: @season_id).take

		season_ast_ratio.value = @ast_ratio
		season_ast_ratio.constituent_stats = {
			"possessions" => @poss,
			"assists" => @assists,
		}
		season_ast_ratio.save
	end

	def oreb_pct()
		@oreb_pct = Stats::Advanced::Team::TeamOffensiveRebPctService.new({
			team_off_reb: @off_reb,
			opp_def_reb: @opp_def_reb
		}).call

		season_off_reb = LineupAdvStat.where(stat_list_id: 33, lineup_id: @lineup_id, is_opponent: false, season_id: @season_id).take

		season_off_reb.value = @oreb_pct
		season_off_reb.constituent_stats = {
			"off_reb" => @off_reb,
			"opp_def_reb" => @opp_def_reb,
		}
		season_off_reb.save
	end

	def dreb_pct()
		@dreb_pct = Stats::Advanced::Team::TeamDefensiveRebPctService.new({
			team_def_reb: @def_reb,
			opp_off_reb: @opp_off_reb
		}).call

		season_def_reb = LineupAdvStat.where(stat_list_id: 34, lineup_id: @lineup_id, is_opponent: false, season_id: @season_id).take
		season_def_reb.value = @dreb_pct
		season_def_reb.constituent_stats = {
			"opp_off_reb" => @opp_off_reb,
			"def_reb" => @def_reb,
		}
		season_def_reb.save
	end

	def efg_pct()
		@efg_pct = Stats::Advanced::EffectiveFgPctService.new({
			field_goals: @field_goals,
			field_goal_att: @field_goal_att,
			three_point_fg: @three_point_fg
		}).call

		season_efg = LineupAdvStat.where(stat_list_id: 18, lineup_id: @lineup_id, is_opponent: false, season_id: @season_id).take
		season_efg.value = @efg_pct
		season_efg.constituent_stats = {
			"field_goals" => @field_goals,
			"field_goal_att" => @field_goal_att,
			"three_point_fg" => @three_point_fg,
		}
		season_efg.save
	end

	def ts_pct()
		@ts_pct = Stats::Advanced::TrueShootingPctService.new({
			points: @points,
			field_goal_att: @field_goal_att,
			free_throw_att: @free_throw_att
		}).call

		season_ts = LineupAdvStat.where(stat_list_id: 19, lineup_id: @lineup_id, is_opponent: false, season_id: @season_id).take

		season_ts.value = @ts_pct
		season_ts.constituent_stats = {
			"points" => @points,
			"field_goal_att" => @field_goal_att,
			"free_throw_att" => @free_throw_att,
		}
		season_ts.save
	end

end
