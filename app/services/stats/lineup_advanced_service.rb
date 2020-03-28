
## TODO: MAKE SURE TO CHECK FOR TEAM STATS!!! I.E. ONLY CALCULATE FOR STATS USER WANTS TO KEEP

class Stats::LineupAdvancedService
	def initialize(params)
		@field_goal_att = params[:field_goal_att]
		@free_throw_att = params[:free_throw_att]
		@turnovers = params[:turnovers]
		@off_reb = params[:off_reb]
		@def_reb = params[:def_reb]
		@field_goals = params[:field_goals]
		@points = params[:points]
		@three_point_fg = params[:three_point_fg]
		@assists = params[:assists]


		@opp_field_goal_att = params[:opp_field_goal_att]
		@opp_free_throw_att = params[:opp_free_throw_att]
		@opp_turnovers = params[:opp_turnovers]
		@opp_off_reb = params[:opp_off_reb]
		@opp_def_reb = params[:opp_def_reb]
		@opp_points = params[:opp_points]
		@lineup_id = params[:lineup_id]
		@team_id = params[:team_id]
		@game_id = params[:game_id]
	end

	def call()
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


		#PIE
	end

	private
	def possessions()
		@poss = Advanced::PossessionsService.new({
			team_field_goal_att:  @field_goal_att,
			team_free_throw_att:  @free_throw_att,
			team_turnovers:  @turnovers,
			team_off_reb: @off_reb
		}).call

		LineupGameAdvancedStat.create({
			stat_list_id: 43,
			lineup_id: @lineup_id,
			game_id: @game_id,
			constituent_stats: {
				"field_goal_att" => @field_goal_att,
				"free_throw_att" => @free_throw_att,
				"turnovers" => @turnovers,
				"off_reb" => @off_reb
			},
			value: @poss,
			is_opponent: false
		})

		@season_poss = LineupAdvStat.where(stat_list_id: 43, lineup_id: @lineup_id, is_opponent: false).take
		if @season_poss
			new_poss = Advanced::PossessionsService.new({
				team_field_goal_att: @field_goal_att + @season_poss.constituent_stats["field_goal_att"],
				team_free_throw_att: @free_throw_att + @season_poss.constituent_stats["free_throw_att"],
				team_turnovers: @turnovers + @season_poss.constituent_stats["turnovers"],
				team_off_reb: @off_reb + @season_poss.constituent_stats["off_reb"],
			}).call

			@season_poss.value = new_poss
			@season_poss.constituent_stats = {
				"field_goal_att" => @field_goal_att + @season_poss.constituent_stats["field_goal_att"],
				"free_throw_att" => @free_throw_att + @season_poss.constituent_stats["free_throw_att"],
				"turnovers" => @turnovers + @season_poss.constituent_stats["turnovers"],
				"off_reb" => @off_reb + @season_poss.constituent_stats["off_reb"],
			}
			@season_poss.save
		else
			@season_poss = LineupAdvStat.create({
				stat_list_id: 43,
				lineup_id: @lineup_id,
				constituent_stats: {
					"field_goal_att" => @field_goal_att,
					"free_throw_att" => @free_throw_att,
					"turnovers" => @turnovers,
					"off_reb" => @off_reb
				},
				value: @poss,
				is_opponent: false
			})
		end

		@opp_poss = Advanced::PossessionsService.new({
			team_field_goal_att:  @opp_field_goal_att,
			team_free_throw_att:  @opp_free_throw_att,
			team_turnovers:  @opp_turnovers,
			team_off_reb: @opp_off_reb
		}).call


		LineupGameAdvancedStat.create({
			stat_list_id: 43,
			lineup_id: @lineup_id,
			game_id: @game_id,
			constituent_stats: {
				"field_goal_att" => @opp_field_goal_att,
				"free_throw_att" => @opp_free_throw_att,
				"turnovers" => @opp_turnovers,
				"off_reb" => @opp_off_reb
			},
			value: @opp_poss,
			is_opponent: true
		})

		@season_opp_poss = LineupAdvStat.where(stat_list_id: 43, lineup_id: @lineup_id, is_opponent: true).take
		if @season_opp_poss
			new_poss = Advanced::PossessionsService.new({
				team_field_goal_att: @opp_field_goal_att + @season_opp_poss.constituent_stats["field_goal_att"],
				team_free_throw_att: @opp_free_throw_att + @season_opp_poss.constituent_stats["free_throw_att"],
				team_turnovers: @opp_turnovers + @season_opp_poss.constituent_stats["turnovers"],
				team_off_reb: @opp_off_reb + @season_opp_poss.constituent_stats["off_reb"],
			}).call

			@season_opp_poss.value = new_poss
			@season_opp_poss.constituent_stats = {
				"field_goal_att" => @opp_field_goal_att + @season_opp_poss.constituent_stats["field_goal_att"],
				"free_throw_att" => @opp_free_throw_att + @season_opp_poss.constituent_stats["free_throw_att"],
				"turnovers" => @opp_turnovers + @season_opp_poss.constituent_stats["turnovers"],
				"off_reb" => @opp_off_reb + @season_opp_poss.constituent_stats["off_reb"],
			}
			@season_opp_poss.save
		else
			@season_opp_poss = LineupAdvStat.create({
				stat_list_id: 43,
				lineup_id: @lineup_id,
				constituent_stats: {
					"field_goal_att" => @opp_field_goal_att,
					"free_throw_att" => @opp_free_throw_att,
					"turnovers" => @opp_turnovers,
					"off_reb" => @opp_off_reb
				},
				value: @opp_poss,
				is_opponent: true
			})
		end
	end

	def offensive_rating()
		@off_rating = Advanced::OffensiveEfficiencyService.new({
			possessions: @poss,
			team_points: @points
		}).call

		LineupGameAdvancedStat.create({
			stat_list_id: 30,
			lineup_id: @lineup_id,
			game_id: @game_id,
			constituent_stats: {
					"possessions" => @poss,
					"points" => @points,
				},
			value: @off_rating,
			is_opponent: false
		})

		season_off_rtg = LineupAdvStat.where(stat_list_id: 30, lineup_id: @lineup_id, is_opponent: false).take
		if season_off_rtg
			@new_off_eff = Advanced::OffensiveEfficiencyService.new({
				possessions: @poss + season_off_rtg.constituent_stats["possessions"],
				team_points: @points + season_off_rtg.constituent_stats["points"],
			}).call

			season_off_rtg.value = @new_off_eff
			season_off_rtg.constituent_stats = {
				"possessions" => @poss + season_off_rtg.constituent_stats["possessions"],
				"points" => @points + season_off_rtg.constituent_stats["points"],
			}
			season_off_rtg.save
		else
			season_off_rtg = LineupAdvStat.create({
				stat_list_id: 30,
				lineup_id: @lineup_id,
				constituent_stats: {
					"possessions" => @poss,
					"points" => @points,
				},
				value: @off_rating,
				is_opponent: false
			})
			@new_off_eff = @off_rating
		end
	end

	def defensive_rating()
		@def_rating = Advanced::DefensiveEfficiencyService.new({
			opp_possessions: @opp_poss,
			opp_points: @opp_points
		}).call

		LineupGameAdvancedStat.create({
			stat_list_id: 31,
			lineup_id: @lineup_id,
			game_id: @game_id,
			constituent_stats: {
					"opp_possessions" => @opp_poss,
					"opp_points" => @opp_points,
				},
			value: @def_rating,
			is_opponent: false
		})

		season_def_rtg = LineupAdvStat.where(stat_list_id: 31, lineup_id: @lineup_id, is_opponent: false).take
		if season_def_rtg
			@new_def_eff = Advanced::DefensiveEfficiencyService.new({
				opp_possessions: @opp_poss + season_def_rtg.constituent_stats["opp_possessions"],
				opp_points: @opp_points + season_def_rtg.constituent_stats["opp_points"],
			}).call

			season_def_rtg.value = @new_def_eff
			season_def_rtg.constituent_stats = {
				"opp_possessions" => @opp_poss + season_def_rtg.constituent_stats["opp_possessions"],
				"opp_points" => @opp_points + season_def_rtg.constituent_stats["opp_points"],
			}
			season_def_rtg.save
		else
			season_def_rtg = LineupAdvStat.create({
				stat_list_id: 31,
				lineup_id: @lineup_id,
				constituent_stats: {
					"opp_possessions" => @opp_poss,
					"opp_points" => @opp_points,
				},
				value: @def_rating,
				is_opponent: false
			})
			@new_def_eff = @def_rating
		end
	end

	def net_rating()
		@net_rating = @off_rating - @def_rating 
	end

	def ast_ratio()
		@ast_ratio = Advanced::AssistRatioService.new({
			possessions: @poss,
			assists: @assists
		}).call

		LineupGameAdvancedStat.create({
			stat_list_id: 52,
			lineup_id: @lineup_id,
			game_id: @game_id,
			constituent_stats: {
					"possessions" => @poss,
					"assists" => @assists,
				},
			value: @ast_ratio,
			is_opponent: false
		})

		season_ast_ratio = LineupAdvStat.where(stat_list_id: 52, lineup_id: @lineup_id, is_opponent: false).take
		if season_ast_ratio
			@new_ast_ratio = Advanced::AssistRatioService.new({
				opp_possessions: @poss + season_ast_ratio.constituent_stats["possessions"],
				assists: @assists + season_ast_ratio.constituent_stats["assists"],
			}).call

			season_ast_ratio.value = @ast_ratio
			season_ast_ratio.constituent_stats = {
				"possessions" => @poss + season_ast_ratio.constituent_stats["possessions"],
				"assists" => @assists + season_ast_ratio.constituent_stats["assists"],
			}
			season_ast_ratio.save
		else
			season_ast_ratio = LineupAdvStat.create({
				stat_list_id: 52,
				lineup_id: @lineup_id,
				constituent_stats: {
					"possessions" => @poss,
					"assists" => @assists,
				},
				value: @ast_ratio,
				is_opponent: false
			})
		end
	end

	def oreb_pct()
		@oreb_pct = Advanced::TeamOffensiveRebPctService.new({
			team_off_reb: @off_reb,
			opp_def_reb: @opp_def_reb
		}).call

		LineupGameAdvancedStat.create({
			stat_list_id: 33,
			lineup_id: @lineup_id,
			game_id: @game_id,
			constituent_stats: {
					"off_reb" => @off_reb,
					"opp_def_reb" => @opp_def_reb,
				},
			value: @oreb_pct,
			is_opponent: false
		})


		season_off_reb = LineupAdvStat.where(stat_list_id: 33, lineup_id: @lineup_id, is_opponent: false).take
		if season_off_reb
			new_oreb = Advanced::TeamOffensiveRebPctService.new({
				team_off_reb: @off_reb + season_off_reb.constituent_stats["off_reb"],
				opp_def_reb: @opp_def_reb + season_off_reb.constituent_stats["opp_def_reb"],
			}).call

			season_off_reb.value = new_oreb
			season_off_reb.constituent_stats = {
				"off_reb" => @off_reb + season_off_reb.constituent_stats["off_reb"],
				"opp_def_reb" => @opp_def_reb + season_off_reb.constituent_stats["opp_def_reb"],
			}
			season_off_reb.save
		else
			season_off_reb = LineupAdvStat.create({
				stat_list_id: 33,
				lineup_id: @lineup_id,
				constituent_stats: {
					"off_reb" => @off_reb,
					"opp_def_reb" => @opp_def_reb,
				},
				value: @oreb_pct,
				is_opponent: false
			})
		end
	end

	def dreb_pct()
		@dreb_pct = Advanced::TeamDefensiveRebPctService.new({
			team_def_reb: @def_reb,
			opp_off_reb: @opp_off_reb
		}).call

		LineupGameAdvancedStat.create({
			stat_list_id: 34,
			lineup_id: @lineup_id,
			game_id: @game_id,
			constituent_stats: {
					"opp_off_reb" => @opp_off_reb,
					"def_reb" => @def_reb,
				},
			value: @dreb_pct,
			is_opponent: false
		})

		season_def_reb = LineupAdvStat.where(stat_list_id: 34, lineup_id: @lineup_id, is_opponent: false).take
		if season_def_reb
			new_dreb = Advanced::TeamDefensiveRebPctService.new({
				opp_off_reb: @opp_off_reb + season_def_reb.constituent_stats["opp_off_reb"],
				team_def_reb: @def_reb + season_def_reb.constituent_stats["def_reb"],
			}).call

			season_def_reb.value = new_dreb
			season_def_reb.constituent_stats = {
				"opp_off_reb" => @opp_off_reb + season_def_reb.constituent_stats["opp_off_reb"],
				"def_reb" => @def_reb + season_def_reb.constituent_stats["def_reb"],
			}
			season_def_reb.save
		else
			season_def_reb = LineupAdvStat.create({
				stat_list_id: 34,
				lineup_id: @lineup_id,
				constituent_stats: {
					"opp_off_reb" => @opp_off_reb,
					"def_reb" => @def_reb,
				},
				value: @dreb_pct,
				is_opponent: false
			})
		end
	end

	def efg_pct()
		@efg_pct = Advanced::EffectiveFgPctService.new({
			field_goals: @field_goals,
			field_goal_att: @field_goal_att,
			three_point_fg: @three_point_fg
		}).call

		LineupGameAdvancedStat.create({
			stat_list_id: 18,
			lineup_id: @lineup_id,
			game_id: @game_id,
			constituent_stats: {
					"field_goals" => @field_goals,
					"field_goal_att" => @field_goal_att,
					"three_point_fg" => @three_point_fg,
				},
			value: @efg_pct,
			is_opponent: false
		})

		season_efg = LineupAdvStat.where(stat_list_id: 18, lineup_id: @lineup_id, is_opponent: false).take
		if season_efg
			new_efg = Advanced::EffectiveFgPctService.new({
				field_goals: @field_goals + season_efg.constituent_stats["field_goals"],
				field_goal_att: @field_goal_att + season_efg.constituent_stats["field_goal_att"],
				three_point_fg: @three_point_fg + season_efg.constituent_stats["three_point_fg"],
			}).call

			season_efg.value = new_efg
			season_efg.constituent_stats = {
				"field_goals" => @field_goals + season_efg.constituent_stats["field_goals"],
				"field_goal_att" => @field_goal_att + season_efg.constituent_stats["field_goal_att"],
				"three_point_fg" => @three_point_fg + season_efg.constituent_stats["three_point_fg"],
			}
			season_efg.save
		else
			season_efg = LineupAdvStat.create({
				stat_list_id: 18,
				lineup_id: @lineup_id,
				constituent_stats: {
					"field_goals" => @field_goals,
					"field_goal_att" => @field_goal_att,
					"three_point_fg" => @three_point_fg,
				},
				value: @efg_pct,
				is_opponent: false
			})
		end
	end

	def ts_pct()
		@ts_pct = Advanced::TrueShootingPctService.new({
			points: @points,
			field_goal_att: @field_goal_att,
			free_throw_att: @free_throw_att
		}).call

		LineupGameAdvancedStat.create({
			stat_list_id: 19,
			lineup_id: @lineup_id,
			game_id: @game_id,
			constituent_stats: {
					"points" => @points,
					"field_goal_att" => @field_goal_att,
					"free_throw_att" => @free_throw_att,
				},
			value: @ts_pct,
			is_opponent: false
		})

		season_ts = LineupAdvStat.where(stat_list_id: 19, lineup_id: @lineup_id, is_opponent: false).take
		if season_ts
			new_ts = Advanced::TrueShootingPctService.new({
				points: @points + season_ts.constituent_stats["points"],
				field_goal_att: @field_goal_att + season_ts.constituent_stats["field_goal_att"],
				free_throw_att: @free_throw_att + season_ts.constituent_stats["free_throw_att"],
			}).call

			season_ts.value = new_ts
			season_ts.constituent_stats = {
				"points" => @points + season_ts.constituent_stats["points"],
				"field_goal_att" => @field_goal_att + season_ts.constituent_stats["field_goal_att"],
				"free_throw_att" => @free_throw_att + season_ts.constituent_stats["free_throw_att"],
			}
			season_ts.save
		else
			season_ts = LineupAdvStat.create({
				stat_list_id: 19,
				lineup_id: @lineup_id,
				constituent_stats: {
					"points" => @points,
					"field_goal_att" => @field_goal_att,
					"free_throw_att" => @free_throw_att,
				},
				value: @ts_pct,
				is_opponent: false
			})
		end
	end

end