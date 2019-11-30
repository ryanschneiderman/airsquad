
class Advanced::SeasonTeamAdvancedStatsService

	def initialize(params)
		@team_id = params[:team_id]
		team = Team.find_by_id(@team_id)
		@minutes_p_q = team.minutes_p_q
		@team_field_goals =  TeamSeasonStat.where(team_id: @team_id, stat_list_id: 1, is_opponent: false).take.value
		@opp_field_goals = TeamSeasonStat.where(team_id: @team_id, stat_list_id: 1, is_opponent: true).take.value
		@team_field_goal_misses =  TeamSeasonStat.where(team_id: @team_id, stat_list_id: 2, is_opponent: false).take.value
		@opp_field_goal_misses =  TeamSeasonStat.where(team_id: @team_id, stat_list_id: 2, is_opponent: true).take.value
		@team_off_reb =  TeamSeasonStat.where(team_id: @team_id, stat_list_id: 4, is_opponent: false).take.value
		@opp_off_reb =  TeamSeasonStat.where(team_id: @team_id, stat_list_id: 4, is_opponent: true).take.value
		@team_def_reb =  TeamSeasonStat.where(team_id: @team_id, stat_list_id: 5, is_opponent: false).take.value
		@opp_def_reb =  TeamSeasonStat.where(team_id: @team_id, stat_list_id: 5, is_opponent: true).take.value
		@team_turnovers = TeamSeasonStat.where(team_id: @team_id, stat_list_id: 7, is_opponent: false).take.value
		@opp_turnovers =  TeamSeasonStat.where(team_id: @team_id, stat_list_id: 7, is_opponent: true).take.value
		@team_free_throw_makes =  TeamSeasonStat.where(team_id: @team_id, stat_list_id: 13, is_opponent: false).take.value
		@opp_free_throw_makes =  TeamSeasonStat.where(team_id: @team_id, stat_list_id: 13, is_opponent: true).take.value
		@team_free_throw_misses =  TeamSeasonStat.where(team_id: @team_id, stat_list_id: 14, is_opponent: false).take.value
		@opp_free_throw_misses =  TeamSeasonStat.where(team_id: @team_id, stat_list_id: 14, is_opponent: true).take.value
		@team_points =  TeamSeasonStat.where(team_id: @team_id, stat_list_id: 15, is_opponent: false).take.value
		@opp_points =  TeamSeasonStat.where(team_id: @team_id, stat_list_id: 15, is_opponent: true).take.value
		@team_three_point_makes = TeamSeasonStat.where(team_id: @team_id, stat_list_id: 11, is_opponent: false).take.value
		@team_three_point_misses = TeamSeasonStat.where(team_id: @team_id, stat_list_id: 12, is_opponent: false).take.value
		@opp_three_point_makes = TeamSeasonStat.where(team_id: @team_id, stat_list_id: 11, is_opponent: true).take.value
		

    	@team_minutes = TeamSeasonStat.where(team_id: @team_id, stat_list_id: 16, is_opponent: false).take.value

		
		@team_three_point_att = @team_three_point_makes + @team_three_point_misses
		@team_field_goal_att = @team_field_goals + @team_field_goal_misses
		@opp_field_goal_att = @opp_field_goals + @opp_field_goal_misses
		@team_free_throw_att = @team_free_throw_makes + @team_free_throw_misses
		@opp_free_throw_att = @opp_free_throw_makes + @opp_free_throw_misses
	end

	def call
		team_advanced_stats = TeamStat.joins(:stat_list).select("stat_lists.advanced as advanced, team_stats.*").where("stat_lists.advanced" => true, "team_stats.team_id" => @team_id).sort_by{|e| e.stat_list_id}
		if team_advanced_stats.any?{|a| a.stat_list_id == 43}
			possessions()
			opp_possessions()
		end
		team_advanced_stats.each do |stat|
			case stat.stat_list_id
			when 18
				effective_fg_pct()
				opp_effective_fg_pct()
			when 21
				three_point_rate()
			when 22
				free_throw_att_rate()
			when 30
				off_efficiency()
			when 31
				def_efficiency()
			when 33
				offensive_reb_pct()
			when 34
				defensive_reb_pct()
			when 38
				turnover_pct()
				opp_turnover_pct()
			when 46
				pace()
			when 47
				free_throw_rate()
				opp_free_throw_rate()
			end
		end

		return {"offensive_efficiency" => @offensive_efficiency, "season_offensive_efficiency" => @new_off_eff,  "defensive_efficiency" => @defensive_efficiency, "season_defensive_efficiency" => @new_def_eff, "possessions" => @possessions, "opp_possessions" => @opp_possessions}

	end

	private

	def possessions()
		@possessions = Advanced::PossessionsService.new({
			team_field_goal_att: @team_field_goal_att,
			team_free_throw_att: @team_free_throw_att,
			team_turnovers: @team_turnovers,
			team_off_reb: @team_off_reb
		}).call


		@season_poss = SeasonTeamAdvStat.where(stat_list_id: 43, team_id: @team_id, is_opponent: false).take

		@season_poss.value = @possessions
		@season_poss.constituent_stats = {
			"team_field_goal_att" => @team_field_goal_att,
			"team_free_throw_att" => @team_free_throw_att,
			"team_turnovers" => @team_turnovers,
			"team_off_reb" => @team_off_reb,
		}
		@season_poss.save
	end

	def opp_possessions()
		@opp_possessions = Advanced::PossessionsService.new({
			team_field_goal_att: @opp_field_goal_att,
			team_free_throw_att: @opp_free_throw_att,
			team_turnovers: @opp_turnovers,
			team_off_reb: @opp_off_reb
		}).call

		@season_opp_poss = SeasonTeamAdvStat.where(stat_list_id: 43, team_id: @team_id, is_opponent: true).take

		@season_opp_poss.value = @opp_possessions
		@season_opp_poss.constituent_stats = {
			"opp_field_goal_att" => @opp_field_goal_att,
			"opp_free_throw_att" => @opp_free_throw_att,
			"opp_turnovers" => @opp_turnovers,
			"opp_off_reb" => @opp_off_reb,
		}
		@season_opp_poss.save
	end

	def off_efficiency()
		@offensive_efficiency = Advanced::OffensiveEfficiencyService.new({
			possessions: @possessions,
			team_points: @team_points,
		}).call

		season_stat = SeasonTeamAdvStat.where(stat_list_id: 30, team_id: @team_id, is_opponent: false).take

		season_stat.value = @offensive_efficiency
		season_stat.constituent_stats = {
			"possessions" => @possessions,
			"team_points" => @team_points,
		}
		season_stat.save
	end

	def def_efficiency()
		@defensive_efficiency = Advanced::DefensiveEfficiencyService.new({
			opp_possessions: @opp_possessions,
			opp_points: @opp_points
		}).call


		season_stat = SeasonTeamAdvStat.where(stat_list_id: 31, team_id: @team_id, is_opponent: false).take

		season_stat.value = @defensive_efficiency
		season_stat.constituent_stats = {
			"opp_possessions" => @opp_possessions,
			"opp_points" => @opp_points,
		}
		season_stat.save
	end

	def pace()
		@pace = Advanced::PaceService.new({
			possessions: @possessions,
			opp_possessions: @opp_possessions,
			team_minutes: @team_minutes,
			minutes_per_game: @minutes_p_q * 4
		}).call


		season_pace.value = @pace
		season_pace.constituent_stats = {
			"possessions" => @possessions,
			"opp_possessions" => @opp_possessions,
			"team_minutes" => @team_minutes,
			"minutes_per_game" => @minutes_p_q * 4,
		}
		season_pace.save
	end

	def free_throw_att_rate
		free_throw_att_rate = Advanced::FreeThrowAttemptRateService.new({
			free_throw_att: @team_free_throw_att,
			field_goal_att: @team_field_goal_att,
		}).call

		season_fta_rate = SeasonTeamAdvStat.where(stat_list_id: 22, team_id: @team_id, is_opponent: false).take

		season_fta_rate.value = free_throw_att_rate
		season_fta_rate.constituent_stats = {
			"team_free_throw_att" => @team_free_throw_att + season_fta_rate.constituent_stats["team_free_throw_att"],
			"team_field_goal_att" => @team_field_goal_att + season_fta_rate.constituent_stats["team_field_goal_att"],
		}
		season_fta_rate.save
	end

	def three_point_rate()
		three_point_rate = Advanced::ThreePtAttemptRateService.new({
			three_point_att: @team_three_point_att,
			field_goal_att: @team_field_goal_att,
		}).call

		season_three_point_rate = SeasonTeamAdvStat.where(stat_list_id: 21, team_id: @team_id, is_opponent: false).take

		season_three_point_rate.value = three_point_rate
		season_three_point_rate.constituent_stats = {
			"team_three_point_att" => @team_free_throw_att,
			"team_field_goal_att" => @team_field_goal_att,
		}
		season_three_point_rate.save
	end

	def effective_fg_pct ()
		eff_fg = Advanced::EffectiveFgPctService.new({
			field_goals: @team_field_goals,
			field_goal_att: @team_field_goal_att,
			three_point_fg: @team_three_point_makes,
		}).call

		season_efg = SeasonTeamAdvStat.where(stat_list_id: 18, team_id: @team_id, is_opponent: false).take

		season_efg.value = eff_fg
		season_efg.constituent_stats = {
			"team_field_goals" => @team_field_goals,
			"team_field_goal_att" => @team_field_goal_att,
			"team_three_point_makes" => @team_three_point_makes,
		}
		season_efg.save
	end

	def opp_effective_fg_pct()
		eff_fg = Advanced::EffectiveFgPctService.new({
			field_goals: @opp_field_goals,
			field_goal_att: @opp_field_goal_att,
			three_point_fg: @opp_three_point_makes,
		}).call


		season_efg = SeasonTeamAdvStat.where(stat_list_id: 18, team_id: @team_id, is_opponent: true).take

		season_efg.value = eff_fg
		season_efg.constituent_stats = {
			"team_field_goals" => @opp_field_goals,
			"team_field_goal_att" => @opp_field_goal_att,
			"team_three_point_makes" => @opp_three_point_makes,
		}
		season_efg.save
	end

	def turnover_pct()
		turnover_pct = Advanced::TurnoverPctService.new({
			turnovers: @team_turnovers,
			field_goal_att: @team_field_goal_att,
			free_throw_att: @team_free_throw_att,
		}).call


		season_tov = SeasonTeamAdvStat.where(stat_list_id: 38, team_id: @team_id, is_opponent: false).take

		season_tov.value = turnover_pct
		season_tov.constituent_stats = {
			"team_turnovers" => @team_turnovers,
			"team_field_goal_att" => @team_field_goal_att,
			"team_free_throw_att" => @team_free_throw_att,
		}
		season_tov.save
	end

	def opp_turnover_pct()
		turnover_pct = Advanced::TurnoverPctService.new({
			turnovers: @opp_turnovers,
			field_goal_att: @opp_field_goal_att,
			free_throw_att: @opp_free_throw_att,
		}).call


		season_tov = SeasonTeamAdvStat.where(stat_list_id: 38, team_id: @team_id, is_opponent: true).take

		season_tov.value = turnover_pct
		season_tov.constituent_stats = {
			"team_turnovers" => @opp_turnovers,
			"team_field_goal_att" => @opp_field_goal_att,
			"team_free_throw_att" => @opp_free_throw_att,
		}
		season_tov.save
	end

	def offensive_reb_pct()
		oreb = Advanced::TeamOffensiveRebPctService.new({
			team_off_reb: @team_off_reb,
			opp_def_reb: @opp_def_reb,
		}).call

		season_off_reb = SeasonTeamAdvStat.where(stat_list_id: 33, team_id: @team_id, is_opponent: false).take
		season_off_reb.value = oreb
		season_off_reb.constituent_stats = {
			"team_off_reb" => @team_off_reb,
			"opp_def_reb" => @opp_def_reb,
		}
		season_off_reb.save
	end

	def defensive_reb_pct()
		dreb = Advanced::TeamDefensiveRebPctService.new({
			opp_off_reb: @opp_off_reb,
			team_def_reb: @team_def_reb,
		}).call

		season_def_reb = SeasonTeamAdvStat.where(stat_list_id: 34, team_id: @team_id, is_opponent: false).take

		season_def_reb.value = dreb
		season_def_reb.constituent_stats = {
			"opp_off_reb" => @opp_off_reb ,
			"team_def_reb" => @team_def_reb,
		}
		season_def_reb.save
	end

	def free_throw_rate()
		if @team_field_goal_att == 0
			free_throw_rate = 0.0
		else 
			free_throw_rate = 100 * (100 * @team_free_throw_makes / @team_field_goal_att).round / 100.0
		end

		@season_ftr = SeasonTeamAdvStat.where(stat_list_id: 47, team_id: @team_id, is_opponent: false).take
		@season_ftr.value = free_throw_rate
		@season_ftr.constituent_stats = {
			"team_free_throw_makes" => @team_free_throw_makes,
			"team_field_goal_att" => @team_field_goal_att,
		}
		@season_ftr.save
	end

	def opp_free_throw_rate()
		if @opp_field_goal_att == 0 
			free_throw_rate = 0.0
		else 
			free_throw_rate = 100 * (100 * @opp_free_throw_makes / @opp_field_goal_att).round / 100.0
		end

		season_ftr = SeasonTeamAdvStat.where(stat_list_id: 47, team_id: @team_id, is_opponent: true).take
		season_ftr.value = free_throw_rate
		season_ftr.constituent_stats = {
			"team_free_throw_makes" => @opp_free_throw_makes,
			"team_field_goal_att" => @opp_field_goal_att,
		}
		season_ftr.save
	end
end
