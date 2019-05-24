

class Advanced::TeamAdvancedStatsService

	def initialize(params)
		@team_field_goals = params[:team_field_goals].to_f 
		@opp_field_goals =params[:opp_field_goals].to_f
		@team_field_goal_misses = params[:team_field_goal_misses].to_f
		@opp_field_goal_misses = params[:opp_field_goal_misses].to_f 
		@team_off_reb = params[:team_off_reb].to_f 
		@opp_off_reb = params[:opp_off_reb].to_f 
		@team_turnovers = params[:team_turnovers].to_f 
		@opp_turnovers = params[:opp_turnovers].to_f 
		@team_free_throw_makes = params[:team_free_throw_makes].to_f 
		@opp_free_throw_makes = params[:opp_free_throw_makes].to_f 
		@team_free_throw_misses = params[:team_free_throw_misses].to_f 
		@opp_free_throw_misses = params[:opp_free_throw_misses].to_f 
		@team_points = params[:team_points].to_f 
		@opp_points = params[:opp_points].to_f 

		@team_field_goal_att = @team_field_goals + @team_field_goal_misses
		@opp_field_goal_att = @opp_field_goals + @opp_field_goal_misses
		@team_free_throw_att = @team_free_throw_makes + @team_free_throw_misses
		@opp_free_throw_att = @opp_free_throw_makes + @opp_free_throw_misses

	end

	def possessions()
		@possessions = Advanced::PossessionsService.new({
			team_field_goal_att: @team_field_goal_att,
			team_free_throw_att: @team_free_throw_att,
			team_turnovers: @team_turnovers,
			team_off_reb: @team_off_reb
		}).call

		AdvancedStat.create({
			stat_list_id: 43,
			member_id: @member_id,
			game_id: @game_id,
			constituent_stats: {
				"team_field_goal_att" => @team_field_goal_att,
				"team_free_throw_att" => @team_free_throw_att,
				"team_turnovers" => @team_turnovers,
				"team_off_reb" => @team_off_reb
			},
			value: @possessions
		})


		season_stat = SeasonAdvancedStat.where(stat_list_id: 43, member_id: @member_id).take
		if season_stat
			new_poss = Advanced::PossessionsService.new({
				team_field_goal_att: @team_field_goal_att + season_stat.constituent_stats["team_field_goal_att"],
				team_free_throw_att: @team_free_throw_att + season_stat.constituent_stats["team_free_throw_att"],
				team_turnovers: @team_turnovers + season_stat.constituent_stats["team_turnovers"],
				team_off_reb: @team_off_reb + season_stat.constituent_stats["team_off_reb"],
			}).call

			season_stat.value = new_poss
			season_stat.constituent_stats = {
				"team_field_goal_att" => @team_field_goal_att + season_stat.constituent_stats["team_field_goal_att"],
				"team_free_throw_att" => @team_free_throw_att + season_stat.constituent_stats["team_free_throw_att"],
				"team_turnovers" => @team_turnovers + season_stat.constituent_stats["team_turnovers"],
				"team_off_reb" => @team_off_reb + season_stat.constituent_stats["team_off_reb"],
			}
			season_stat.save
		else
			
			SeasonAdvancedStat.create({
				stat_list_id: 43,
				member_id: @member_id,
				constituent_stats: {
					"team_field_goal_att" => @team_field_goal_att,
					"team_free_throw_att" => @team_free_throw_att,
					"team_turnovers" => @team_turnovers,
					"team_off_reb" => @team_off_reb
				},
				value: @possessions
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

		AdvancedStat.create({
			stat_list_id: 45,
			member_id: @member_id,
			game_id: @game_id,
			constituent_stats: {
				"opp_field_goal_att" => @opp_field_goal_att,
				"opp_free_throw_att" => @opp_free_throw_att,
				"opp_turnovers" => @opp_turnovers,
				"opp_off_reb" => @opp_off_reb
			},
			value: @opp_possessions
		})

		season_stat = SeasonAdvancedStat.where(stat_list_id: 45, member_id: @member_id).take
		if season_stat
			new_opp_poss = Advanced::PossessionsService.new({
				opp_field_goal_att: @opp_field_goal_att + season_stat.constituent_stats["opp_field_goal_att"],
				opp_free_throw_att: @opp_free_throw_att + season_stat.constituent_stats["opp_free_throw_att"],
				opp_turnovers: @opp_turnovers + season_stat.constituent_stats["opp_turnovers"],
				opp_off_reb: @opp_off_reb + season_stat.constituent_stats["opp_off_reb"],
			}).call

			season_stat.value = new_opp_poss
			season_stat.constituent_stats = {
				"opp_field_goal_att" => @opp_field_goal_att + season_stat.constituent_stats["opp_field_goal_att"],
				"opp_free_throw_att" => @opp_free_throw_att + season_stat.constituent_stats["opp_free_throw_att"],
				"opp_turnovers" => @opp_turnovers + season_stat.constituent_stats["opp_turnovers"],
				"opp_off_reb" => @opp_off_reb + season_stat.constituent_stats["opp_off_reb"],
			}
			season_stat.save
		else
			
			SeasonAdvancedStat.create({
				stat_list_id: 45,
				member_id: @member_id,
				constituent_stats: {
					"opp_field_goal_att" => @opp_field_goal_att,
					"opp_free_throw_att" => @opp_free_throw_att,
					"opp_turnovers" => @opp_turnovers,
					"opp_off_reb" => @opp_off_reb
				},
				value: @possessions
			})
		end
	end

	def off_efficiency()
		@offensive_efficiency = Advanced::OffensiveEfficiencyService.new({
			possessions: possessions,
			team_points: @team_points,
		}).call

		AdvancedStat.create({
			stat_list_id: 30,
			member_id: @member_id,
			game_id: @game_id,
			constituent_stats: {
				"possessions" => possessions,
				"team_points" => @team_points,
			},
			value: @offensive_efficiency
		})

		season_stat = SeasonAdvancedStat.where(stat_list_id: 30, member_id: @member_id).take
		if season_stat
			@new_off_eff = Advanced::OffensiveEfficiencyService.new({
				possessions: @possessions + season_stat.constituent_stats["possessions"],
				team_points: @team_points + season_stat.constituent_stats["team_points"],
			}).call

			season_stat.value = new_off_eff
			season_stat.constituent_stats = {
				"possessions" => possessions + season_stat.constituent_stats["possessions"],
				"team_points" => @team_points + season_stat.constituent_stats["team_points"],
			}
			season_stat.save
		else
			
			SeasonAdvancedStat.create({
				stat_list_id: 30,
				member_id: @member_id,
				constituent_stats: {
					"possessions" => possessions,
					"team_points" => @team_points,
				},
				value: @offensive_efficiency
			})
		end
	end

	def def_efficiency()
		@defensive_efficiency = Advanced::DefensiveEfficiencyService.new({
			opp_possessions: opp_possessions,
			opp_points: @opp_points
		}).call

		AdvancedStat.create({
			stat_list_id: 31,
			member_id: @member_id,
			game_id: @game_id,
			constituent_stats: {
				"opp_possessions" => opp_possessions,
				"opp_points" => @opp_points,
			},
			value: @defensive_efficiency
		})

		season_stat = SeasonAdvancedStat.where(stat_list_id: 31, member_id: @member_id).take
		if season_stat
			@new_def_eff = Advanced::DefensiveEfficiencyService.new({
				opp_possessions: @possessions + season_stat.constituent_stats["opp_possessions"],
				opp_points: @opp_points + season_stat.constituent_stats["opp_points"],
			}).call

			season_stat.value = new_def_eff
			season_stat.constituent_stats = {
				"opp_possessions" => opp_possessions + season_stat.constituent_stats["opp_possessions"],
				"opp_points" => @opp_points + season_stat.constituent_stats["opp_points"],
			}
			season_stat.save
		else
			SeasonAdvancedStat.create({
				stat_list_id: 31,
				member_id: @member_id,
				constituent_stats: {
					"opp_possessions" => opp_possessions,
					"opp_points" => @opp_points,
				},
				value: @defensive_efficiency
			})
		end
	end

	def minutes()

	end

	def call
		possessions()
		opp_possessions()
		off_efficiency()
		def_efficiency()
		minutes()


		return {"offensive_efficiency" => @offensive_efficiency, "season_offensive_efficiency" => @new_off_eff,  "defensive_efficiency" => @defensive_efficiency, "season_defensive_efficiency" => @new_def_eff "possessions" => @possessions, "opp_possessions" => @opp_possessions}

	end

end
