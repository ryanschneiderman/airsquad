
class Advanced::TeamAdvancedStatsService

	def initialize(params)
		@team_field_goals = params[:team_field_goals].to_f 
		@opp_field_goals =params[:opp_field_goals].to_f
		@team_field_goal_misses = params[:team_field_goal_misses].to_f
		@opp_field_goal_misses = params[:opp_field_goal_misses].to_f 
		@team_off_reb = params[:team_off_reb].to_f 
		@opp_off_reb = params[:opp_off_reb].to_f 
		@team_def_reb = params[:team_def_reb].to_f
		@opp_def_reb = params[:opp_def_reb].to_f
		@team_turnovers = params[:team_turnovers].to_f 
		@opp_turnovers = params[:opp_turnovers].to_f 
		@team_free_throw_makes = params[:team_free_throw_makes].to_f 
		@opp_free_throw_makes = params[:opp_free_throw_makes].to_f 
		@team_free_throw_misses = params[:team_free_throw_misses].to_f 
		@opp_free_throw_misses = params[:opp_free_throw_misses].to_f 
		@team_points = params[:team_points].to_f 
		@opp_points = params[:opp_points].to_f 
		@game_id = params[:game_id]
		@team_id = params[:team_id]
		@minutes_p_q = params[:minutes_p_q]
		@team_minutes = params[:team_minutes]
		@season_minutes = params[:team_season_minutes]
		@team_three_point_makes = params[:team_three_point_makes]
		@team_three_point_misses = params[:team_three_point_misses]
		@opp_three_point_makes = params[:opp_three_point_makes]

		@team_three_point_att = @team_three_point_makes + @team_three_point_misses
		@team_field_goal_att = @team_field_goals + @team_field_goal_misses
		@opp_field_goal_att = @opp_field_goals + @opp_field_goal_misses
		@team_free_throw_att = @team_free_throw_makes + @team_free_throw_misses
		@opp_free_throw_att = @opp_free_throw_makes + @opp_free_throw_misses

	end

	def call
		team_advanced_stats = TeamStat.joins(:stat_list).select("stat_lists.advanced as advanced, team_stats.*").where("stat_lists.advanced" => true, "team_stat.team_id" => @team_id).sort_by{|e| e.stat_list_id}
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
			when 43
				possessions()
				opp_possessions()
			when 48
				pace()
			when 49
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

		TeamAdvancedStat.create({
			stat_list_id: 43,
			game_id: @game_id,
			constituent_stats: {
				"team_field_goal_att" => @team_field_goal_att,
				"team_free_throw_att" => @team_free_throw_att,
				"team_turnovers" => @team_turnovers,
				"team_off_reb" => @team_off_reb
			},
			value: @possessions,
			is_opponent: false
		})


		@season_poss = SeasonTeamAdvStat.where(stat_list_id: 43, team_id: @team_id, is_opponent: false).take
		if @season_poss
			new_poss = Advanced::PossessionsService.new({
				team_field_goal_att: @team_field_goal_att + @season_poss.constituent_stats["team_field_goal_att"],
				team_free_throw_att: @team_free_throw_att + @season_poss.constituent_stats["team_free_throw_att"],
				team_turnovers: @team_turnovers + @season_poss.constituent_stats["team_turnovers"],
				team_off_reb: @team_off_reb + @season_poss.constituent_stats["team_off_reb"],
			}).call

			@season_poss.value = new_poss
			@season_poss.constituent_stats = {
				"team_field_goal_att" => @team_field_goal_att + @season_poss.constituent_stats["team_field_goal_att"],
				"team_free_throw_att" => @team_free_throw_att + @season_poss.constituent_stats["team_free_throw_att"],
				"team_turnovers" => @team_turnovers + @season_poss.constituent_stats["team_turnovers"],
				"team_off_reb" => @team_off_reb + @season_poss.constituent_stats["team_off_reb"],
			}
			@season_poss.save
		else
			@season_poss = SeasonTeamAdvStat.create({
				stat_list_id: 43,
				team_id: @team_id,
				constituent_stats: {
					"team_field_goal_att" => @team_field_goal_att,
					"team_free_throw_att" => @team_free_throw_att,
					"team_turnovers" => @team_turnovers,
					"team_off_reb" => @team_off_reb
				},
				value: @possessions,
				is_opponent: false
			})
		end
	end

	def opp_possessions()
		@opp_possessions = Advanced::PossessionsService.new({
			team_field_goal_att: @opp_field_goal_att,
			team_free_throw_att: @opp_free_throw_att,
			team_turnovers: @opp_turnovers,
			team_off_reb: @opp_off_reb
		}).call

		TeamAdvancedStat.create({
			stat_list_id: 43,
			game_id: @game_id,
			constituent_stats: {
				"opp_field_goal_att" => @opp_field_goal_att,
				"opp_free_throw_att" => @opp_free_throw_att,
				"opp_turnovers" => @opp_turnovers,
				"opp_off_reb" => @opp_off_reb
			},
			value: @opp_possessions,
			is_opponent: true
		})

		@season_opp_poss = SeasonTeamAdvStat.where(stat_list_id: 45, team_id: @team_id, is_opponent: true).take
		if @season_opp_poss
			new_opp_poss = Advanced::PossessionsService.new({
				team_field_goal_att: @opp_field_goal_att + @season_opp_poss.constituent_stats["opp_field_goal_att"],
				team_free_throw_att: @opp_free_throw_att + @season_opp_poss.constituent_stats["opp_free_throw_att"],
				team_turnovers: @opp_turnovers + @season_opp_poss.constituent_stats["opp_turnovers"],
				team_off_reb: @opp_off_reb + @season_opp_poss.constituent_stats["opp_off_reb"],
			}).call

			@season_opp_poss.value = new_opp_poss
			@season_opp_poss.constituent_stats = {
				"opp_field_goal_att" => @opp_field_goal_att + @season_opp_poss.constituent_stats["opp_field_goal_att"],
				"opp_free_throw_att" => @opp_free_throw_att + @season_opp_poss.constituent_stats["opp_free_throw_att"],
				"opp_turnovers" => @opp_turnovers + @season_opp_poss.constituent_stats["opp_turnovers"],
				"opp_off_reb" => @opp_off_reb + @season_opp_poss.constituent_stats["opp_off_reb"],
			}
			@season_opp_poss.save
		else
			
			SeasonTeamAdvStat.create({
				stat_list_id: 43,
				team_id: @team_id,
				constituent_stats: {
					"opp_field_goal_att" => @opp_field_goal_att,
					"opp_free_throw_att" => @opp_free_throw_att,
					"opp_turnovers" => @opp_turnovers,
					"opp_off_reb" => @opp_off_reb
				},
				value: @possessions,
				is_opponent: true
			})
		end
	end

	def off_efficiency()
		@offensive_efficiency = Advanced::OffensiveEfficiencyService.new({
			possessions: @possessions,
			team_points: @team_points,
		}).call

		TeamAdvancedStat.create({
			stat_list_id: 30,
			game_id: @game_id,
			constituent_stats: {
				"possessions" => @possessions,
				"team_points" => @team_points,
			},
			value: @offensive_efficiency,
			is_opponent: false,
		})

		season_stat = SeasonTeamAdvStat.where(stat_list_id: 30, team_id: @team_id, is_opponent: false).take
		if season_stat
			puts "SEASON STAT EXISTS"
			@new_off_eff = Advanced::OffensiveEfficiencyService.new({
				possessions: @possessions + season_stat.constituent_stats["possessions"],
				team_points: @team_points + season_stat.constituent_stats["team_points"],
			}).call

			season_stat.value = @new_off_eff
			season_stat.constituent_stats = {
				"possessions" => @possessions + season_stat.constituent_stats["possessions"],
				"team_points" => @team_points + season_stat.constituent_stats["team_points"],
			}
			season_stat.save
		else
			
			season_stat = SeasonTeamAdvStat.create({
				stat_list_id: 30,
				team_id: @team_id,
				constituent_stats: {
					"possessions" => @possessions,
					"team_points" => @team_points,
				},
				value: @offensive_efficiency,
				is_opponent: false
			})
			@new_off_eff = @offensive_efficiency
		end
		puts "season OFFENSIVE EFFICIENCY"
		puts season_stat.value
	end

	def def_efficiency()
		@defensive_efficiency = Advanced::DefensiveEfficiencyService.new({
			opp_possessions: @opp_possessions,
			opp_points: @opp_points
		}).call

		TeamAdvancedStat.create({
			stat_list_id: 31,
			game_id: @game_id,
			constituent_stats: {
				"opp_possessions" => @opp_possessions,
				"opp_points" => @opp_points,
			},
			value: @defensive_efficiency,
			is_opponent: false
		})

		season_stat = SeasonTeamAdvStat.where(stat_list_id: 31, team_id: @team_id, is_opponent: false).take
		if season_stat
			@new_def_eff = Advanced::DefensiveEfficiencyService.new({
				opp_possessions: @opp_possessions + season_stat.constituent_stats["opp_possessions"],
				opp_points: @opp_points + season_stat.constituent_stats["opp_points"],
			}).call

			season_stat.value = @new_def_eff
			season_stat.constituent_stats = {
				"opp_possessions" => @opp_possessions + season_stat.constituent_stats["opp_possessions"],
				"opp_points" => @opp_points + season_stat.constituent_stats["opp_points"],
			}
			season_stat.save
		else
			season_stat = SeasonTeamAdvStat.create({
				stat_list_id: 31,
				team_id: @team_id,
				constituent_stats: {
					"opp_possessions" => @opp_possessions,
					"opp_points" => @opp_points,
				},
				value: @defensive_efficiency,
				is_opponent: false
			})
			@new_def_eff = @defensive_efficiency
		end
	end

	def pace()
		@pace = Advanced::PaceService.new({
			possessions: @possessions,
			opp_possessions: @opp_possessions,
			team_minutes: @team_minutes,
			minutes_per_game: @minutes_p_q * 4
		}).call

		TeamAdvancedStat.create({
			stat_list_id: 48,
			game_id: @game_id,
			constituent_stats: {
				"possessions" => @possessions,
				"opp_possessions" => @opp_possessions,
				"team_minutes" => @team_minutes,
				"minutes_per_game" => @minutes_p_q * 4
			},
			value: @pace,
			is_opponent: false
		})

		season_pace = SeasonTeamAdvStat.where(stat_list_id: 48, team_id: @team_id, is_opponent: false).take
		if season_pace
			@new_pace = Advanced::PaceService.new({
				possessions: @possessions + season_pace.constituent_stats["possessions"],
				opp_possessions: @opp_possessions + season_pace.constituent_stats["opp_possessions"],
				team_minutes: @team_minutes + season_pace.constituent_stats["team_minutes"],
				minutes_per_game: season_pace.constituent_stats["minutes_per_game"],
			}).call

			season_pace.value = @new_pace
			season_pace.constituent_stats = {
				"possessions" => @possessions + season_pace.constituent_stats["possessions"],
				"opp_possessions" => @opp_possessions + season_pace.constituent_stats["opp_possessions"],
				"team_minutes" => @team_minutes + season_pace.constituent_stats["team_minutes"],
				"minutes_per_game" => season_pace.constituent_stats["minutes_per_game"],
			}
			season_pace.save
		else
			season_pace = SeasonTeamAdvStat.create({
				stat_list_id: 48,
				team_id: @team_id,
				constituent_stats: {
					"possessions" => @possessions,
					"opp_possessions" => @opp_possessions,
					"team_minutes" => @team_minutes,
					"minutes_per_game" => @minutes_p_q * 4
				},
				value: @pace,
				is_opponent: false
				})
		end

	end

	def free_throw_att_rate
		free_throw_att_rate = Advanced::FreeThrowAttemptRateService.new({
			free_throw_att: @team_free_throw_att,
			field_goal_att: @team_field_goal_att,
		}).call

		TeamAdvancedStat.create({
			stat_list_id: 22,
			game_id: @game_id,
			constituent_stats: {
				"team_free_throw_att" => @team_free_throw_att,
				"team_field_goal_att" => @team_field_goal_att,
			},
			value: free_throw_att_rate,
			is_opponent: false
		})

		season_fta_rate = SeasonTeamAdvStat.where(stat_list_id: 22, team_id: @team_id, is_opponent: false).take
		if season_fta_rate
			@new_fta_rate = Advanced::FreeThrowAttemptRateService.new({
				free_throw_att: @team_free_throw_att + season_fta_rate.constituent_stats["team_free_throw_att"],
				field_goal_att: @team_field_goal_att + season_fta_rate.constituent_stats["team_field_goal_att"],
			}).call

			season_fta_rate.value = @new_fta_rate
			season_fta_rate.constituent_stats = {
				"team_free_throw_att" => @team_free_throw_att + season_fta_rate.constituent_stats["team_free_throw_att"],
				"team_field_goal_att" => @team_field_goal_att + season_fta_rate.constituent_stats["team_field_goal_att"],
			}
			season_fta_rate.save
		else
			season_fta_rate = SeasonTeamAdvStat.create({
				stat_list_id: 22,
				team_id: @team_id,
				constituent_stats: {
					"team_free_throw_att" => @team_free_throw_att,
					"team_field_goal_att" => @team_field_goal_att,
				},
				value: free_throw_att_rate,
				is_opponent: false
				})
		end
	end

	def three_point_rate()
		three_point_rate = Advanced::ThreePtAttemptRateService.new({
			three_point_att: @team_three_point_att,
			field_goal_att: @team_field_goal_att,
		}).call

		TeamAdvancedStat.create({
			stat_list_id: 21,
			game_id: @game_id,
			constituent_stats: {
				"team_three_point_att" => @team_three_point_att,
				"team_field_goal_att" => @team_field_goal_att,
			},
			value: three_point_rate,
			is_opponent: false
		})

		season_three_point_rate = SeasonTeamAdvStat.where(stat_list_id: 21, team_id: @team_id, is_opponent: false).take
		if season_three_point_rate
			new_tp_rate = Advanced::ThreePtAttemptRateService.new({
				three_point_att: @team_three_point_att + season_three_point_rate.constituent_stats["team_three_point_att"],
				field_goal_att: @team_field_goal_att + season_three_point_rate.constituent_stats["team_field_goal_att"],
			}).call

			season_three_point_rate.value = new_tp_rate
			season_three_point_rate.constituent_stats = {
				"team_three_point_att" => @team_free_throw_att + season_three_point_rate.constituent_stats["team_three_point_att"],
				"team_field_goal_att" => @team_field_goal_att + season_three_point_rate.constituent_stats["team_field_goal_att"],
			}
			season_three_point_rate.save
		else
			season_three_point_rate = SeasonTeamAdvStat.create({
				stat_list_id: 21,
				team_id: @team_id,
				constituent_stats: {
					"team_three_point_att" => @team_three_point_att,
					"team_field_goal_att" => @team_field_goal_att,
				},
				value: three_point_rate,
				is_opponent: false
				})
		end
	end

	def effective_fg_pct ()
		eff_fg = Advanced::EffectiveFgPctService.new({
			field_goals: @team_field_goals,
			field_goal_att: @team_field_goal_att,
			three_point_fg: @team_three_point_makes,
		}).call

		TeamAdvancedStat.create({
			stat_list_id: 18,
			game_id: @game_id,
			constituent_stats: {
				"team_field_goals" => @team_field_goals,
				"team_field_goal_att" => @team_field_goal_att,
				"team_three_point_makes" => @team_three_point_makes,
			},
			value: eff_fg,
			is_opponent: false
		})

		season_efg = SeasonTeamAdvStat.where(stat_list_id: 18, team_id: @team_id, is_opponent: false).take
		if season_efg
			new_efg = Advanced::EffectiveFgPctService.new({
				field_goals: @team_field_goals + season_efg.constituent_stats["team_field_goals"],
				field_goal_att: @team_field_goal_att + season_efg.constituent_stats["team_field_goal_att"],
				three_point_fg: @team_three_point_makes + season_efg.constituent_stats["team_three_point_makes"],
			}).call

			season_efg.value = new_efg
			season_efg.constituent_stats = {
				"team_field_goals" => @team_field_goals + season_efg.constituent_stats["team_field_goals"],
				"team_field_goal_att" => @team_field_goal_att + season_efg.constituent_stats["team_field_goal_att"],
				"team_three_point_makes" => @team_three_point_makes + season_efg.constituent_stats["team_three_point_makes"],
			}
			season_efg.save
		else
			season_efg = SeasonTeamAdvStat.create({
				stat_list_id: 18,
				team_id: @team_id,
				constituent_stats: {
					"team_field_goals" => @team_field_goals,
					"team_field_goal_att" => @team_field_goal_att,
					"team_three_point_makes" => @team_three_point_makes,
				},
				value: eff_fg,
				is_opponent: false
			})
		end
	end

	def opp_effective_fg_pct()
		eff_fg = Advanced::EffectiveFgPctService.new({
			field_goals: @opp_field_goals,
			field_goal_att: @opp_field_goal_att,
			three_point_fg: @opp_three_point_makes,
		}).call

		TeamAdvancedStat.create({
			stat_list_id: 18,
			game_id: @game_id,
			constituent_stats: {
				"team_field_goals" => @opp_field_goals,
				"team_field_goal_att" => @opp_field_goal_att,
				"team_three_point_makes" => @opp_three_point_makes,
			},
			value: eff_fg,
			is_opponent: true
		})

		season_efg = SeasonTeamAdvStat.where(stat_list_id: 18, team_id: @team_id, is_opponent: true).take
		if season_efg
			new_efg = Advanced::EffectiveFgPctService.new({
				field_goals: @opp_field_goals + season_efg.constituent_stats["team_field_goals"],
				field_goal_att: @opp_field_goal_att + season_efg.constituent_stats["team_field_goal_att"],
				three_point_fg: @opp_three_point_makes + season_efg.constituent_stats["team_three_point_makes"],
			}).call

			season_efg.value = new_efg
			season_efg.constituent_stats = {
				"team_field_goals" => @opp_field_goals + season_efg.constituent_stats["team_field_goals"],
				"team_field_goal_att" => @opp_field_goal_att + season_efg.constituent_stats["team_field_goal_att"],
				"team_three_point_makes" => @opp_three_point_makes + season_efg.constituent_stats["team_three_point_makes"],
			}
			season_efg.save
		else
			season_efg = SeasonTeamAdvStat.create({
				stat_list_id: 18,
				team_id: @team_id,
				constituent_stats: {
					"team_field_goals" => @opp_field_goals,
					"team_field_goal_att" => @opp_field_goal_att,
					"team_three_point_makes" => @opp_three_point_makes,
				},
				value: eff_fg,
				is_opponent: true
			})
		end
	end

	def turnover_pct()
		turnover_pct = Advanced::TurnoverPctService.new({
			turnovers: @team_turnovers,
			field_goal_att: @team_field_goal_att,
			free_throw_att: @team_free_throw_att,
		}).call

		TeamAdvancedStat.create({
			stat_list_id: 38,
			game_id: @game_id,
			constituent_stats: {
				"team_turnovers" => @team_turnovers,
				"team_field_goal_att" => @team_field_goal_att,
				"team_free_throw_att" => @team_free_throw_att,
			},
			value: turnover_pct,
			is_opponent: false
		})

		season_tov = SeasonTeamAdvStat.where(stat_list_id: 38, team_id: @team_id, is_opponent: false).take
		if season_tov
			new_tov = Advanced::TurnoverPctService.new({
				turnovers: @team_turnovers + season_tov.constituent_stats["team_turnovers"],
				field_goal_att: @team_field_goal_att + season_tov.constituent_stats["team_field_goal_att"],
				free_throw_att: @team_free_throw_att + season_tov.constituent_stats["team_free_throw_att"],
			}).call

			season_tov.value = new_tov
			season_tov.constituent_stats = {
				"team_turnovers" => @team_turnovers + season_tov.constituent_stats["team_turnovers"],
				"team_field_goal_att" => @team_field_goal_att + season_tov.constituent_stats["team_field_goal_att"],
				"team_free_throw_att" => @team_free_throw_att + season_tov.constituent_stats["team_free_throw_att"],
			}
			season_tov.save
		else
			season_tov = SeasonTeamAdvStat.create({
				stat_list_id: 38,
				team_id: @team_id,
				constituent_stats: {
					"team_turnovers" => @team_turnovers,
					"team_field_goal_att" => @team_field_goal_att,
					"team_free_throw_att" => @team_free_throw_att,
				},
				value: turnover_pct,
				is_opponent: false
			})
		end
	end

	def opp_turnover_pct()
		turnover_pct = Advanced::TurnoverPctService.new({
			turnovers: @opp_turnovers,
			field_goal_att: @opp_field_goal_att,
			free_throw_att: @opp_free_throw_att,
		}).call

		TeamAdvancedStat.create({
			stat_list_id: 38,
			game_id: @game_id,
			constituent_stats: {
				"team_turnovers" => @opp_turnovers,
				"team_field_goal_att" => @opp_field_goal_att,
				"team_free_throw_att" => @opp_free_throw_att,
			},
			value: turnover_pct,
			is_opponent: true
		})

		season_tov = SeasonTeamAdvStat.where(stat_list_id: 38, team_id: @team_id, is_opponent: true).take
		if season_tov
			new_tov = Advanced::TurnoverPctService.new({
				turnovers: @opp_turnovers + season_tov.constituent_stats["team_turnovers"],
				field_goal_att: @opp_field_goal_att + season_tov.constituent_stats["team_field_goal_att"],
				free_throw_att: @opp_free_throw_att + season_tov.constituent_stats["team_free_throw_att"],
			}).call

			season_tov.value = new_tov
			season_tov.constituent_stats = {
				"team_turnovers" => @opp_turnovers + season_tov.constituent_stats["team_turnovers"],
				"team_field_goal_att" => @opp_field_goal_att + season_tov.constituent_stats["team_field_goal_att"],
				"team_free_throw_att" => @opp_free_throw_att + season_tov.constituent_stats["team_free_throw_att"],
			}
			season_tov.save
		else
			season_tov = SeasonTeamAdvStat.create({
				stat_list_id: 38,
				team_id: @team_id,
				constituent_stats: {
					"team_turnovers" => @opp_turnovers,
					"team_field_goal_att" => @opp_field_goal_att,
					"team_free_throw_att" => @opp_free_throw_att,
				},
				value: turnover_pct,
				is_opponent: true
			})
		end
	end

	def offensive_reb_pct()
		oreb = Advanced::TeamOffensiveRebPctService.new({
			team_off_reb: @team_off_reb,
			opp_def_reb: @opp_def_reb,
		}).call

		TeamAdvancedStat.create({
			stat_list_id: 33,
			game_id: @game_id,
			constituent_stats: {
				"team_off_reb" => @team_off_reb,
				"opp_def_reb" => @opp_def_reb,

			},
			value: oreb,
			is_opponent: false
		})


		season_off_reb = SeasonTeamAdvStat.where(stat_list_id: 33, team_id: @team_id, is_opponent: false).take
		if season_off_reb
			new_oreb = Advanced::TeamOffensiveRebPctService.new({
				team_off_reb: @team_off_reb + season_off_reb.constituent_stats["team_off_reb"],
				opp_def_reb: @opp_def_reb + season_off_reb.constituent_stats["opp_def_reb"],
			}).call

			season_off_reb.value = new_oreb
			season_off_reb.constituent_stats = {
				"team_off_reb" => @team_off_reb + season_off_reb.constituent_stats["team_off_reb"],
				"opp_def_reb" => @opp_def_reb + season_off_reb.constituent_stats["opp_def_reb"],
			}
			season_off_reb.save
		else
			season_off_reb = SeasonTeamAdvStat.create({
				stat_list_id: 33,
				team_id: @team_id,
				constituent_stats: {
					"team_off_reb" => @team_off_reb,
					"opp_def_reb" => @opp_def_reb,
				},
				value: oreb,
				is_opponent: false
			})
		end
	end

	def defensive_reb_pct()
		dreb = Advanced::TeamDefensiveRebPctService.new({
			opp_off_reb: @opp_off_reb,
			team_def_reb: @team_def_reb,
		}).call

		TeamAdvancedStat.create({
			stat_list_id: 34,
			game_id: @game_id,
			constituent_stats: {
				"opp_off_reb" => @opp_off_reb,
				"team_def_reb" => @team_def_reb,

			},
			value: dreb,
			is_opponent: false
		})

		season_def_reb = SeasonTeamAdvStat.where(stat_list_id: 34, team_id: @team_id, is_opponent: false).take
		if season_def_reb
			new_dreb = Advanced::TeamDefensiveRebPctService.new({
				opp_off_reb: @opp_off_reb + season_def_reb.constituent_stats["opp_off_reb"],
				team_def_reb: @team_def_reb + season_def_reb.constituent_stats["team_def_reb"],
			}).call

			season_def_reb.value = new_dreb
			season_def_reb.constituent_stats = {
				"opp_off_reb" => @opp_off_reb + season_def_reb.constituent_stats["opp_off_reb"],
				"team_def_reb" => @team_def_reb + season_def_reb.constituent_stats["team_def_reb"],
			}
			season_def_reb.save
		else
			season_def_reb = SeasonTeamAdvStat.create({
				stat_list_id: 34,
				team_id: @team_id,
				constituent_stats: {
					"opp_off_reb" => @opp_off_reb,
					"team_def_reb" => @team_def_reb,
				},
				value: dreb,
				is_opponent: false
			})
		end
	end

	def free_throw_rate()
		if @team_field_goal_att == 0
			free_throw_rate = 0.0
		else 
			free_throw_rate = (100 * @team_free_throw_makes / @team_field_goal_att).round / 100.0
		end
		TeamAdvancedStat.create({
			stat_list_id: 49,
			game_id: @game_id,
			constituent_stats: {
				"team_free_throw_makes" => @team_free_throw_makes,
				"team_field_goal_att" => @team_field_goal_att,
			},
			value: free_throw_rate,
			is_opponent: false
		})

		@season_ftr = SeasonTeamAdvStat.where(stat_list_id: 49, team_id: @team_id, is_opponent: false).take
		if @season_ftr
			@season_ftr.value = @team_free_throw_makes + @season_ftr.constituent_stats["team_free_throw_makes"] / @team_field_goal_att + @season_ftr.constituent_stats["team_field_goal_att"]
			@season_ftr.constituent_stats = {
				"team_free_throw_makes" => @team_free_throw_makes + @season_ftr.constituent_stats["team_free_throw_makes"],
				"team_field_goal_att" => @team_field_goal_att + @season_ftr.constituent_stats["team_field_goal_att"],
			}
			@season_ftr.save
		else
			@season_ftr = SeasonTeamAdvStat.create({
				stat_list_id: 49,
				team_id: @team_id,
				constituent_stats: {
					"team_free_throw_makes" => @team_free_throw_makes,
					"team_field_goal_att" => @team_field_goal_att,
				},
				value: free_throw_rate,
				is_opponent: false
			})
		end
	end

	def opp_free_throw_rate()
		if @opp_field_goal_att == 0 
			free_throw_rate = 0.0
		else 
			free_throw_rate = (100 * @opp_free_throw_makes / @opp_field_goal_att).round / 100.0
		end
		TeamAdvancedStat.create({
			stat_list_id: 49,
			game_id: @game_id,
			constituent_stats: {
				"team_free_throw_makes" => @opp_free_throw_makes,
				"team_field_goal_att" => @opp_field_goal_att,
			},
			value: free_throw_rate,
			is_opponent: true
		})

		season_ftr = SeasonTeamAdvStat.where(stat_list_id: 49, team_id: @team_id, is_opponent: true).take
		if season_ftr
			season_ftr.value = (100 * (@opp_free_throw_makes + season_ftr.constituent_stats["team_free_throw_makes"] / @opp_field_goal_att + season_ftr.constituent_stats["team_field_goal_att"])).round / 100.0
			season_ftr.constituent_stats = {
				"team_free_throw_makes" => @opp_free_throw_makes + season_ftr.constituent_stats["team_free_throw_makes"],
				"team_field_goal_att" => @opp_field_goal_att + season_ftr.constituent_stats["team_field_goal_att"],
			}
			season_ftr.save
		else
			season_ftr = SeasonTeamAdvStat.create({
				stat_list_id: 49,
				team_id: @team_id,
				constituent_stats: {
					"team_free_throw_makes" => @opp_free_throw_makes,
					"team_field_goal_att" => @opp_field_goal_att,
				},
				value: free_throw_rate,
				is_opponent: true
			})
		end
	end
end
