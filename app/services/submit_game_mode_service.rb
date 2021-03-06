## create granule objects for each granule in granules (its an array)
## create player_stat objects for each player_stat in player_stats (its an array)
## save them both 
## redirect to game path

require 'json'

class SubmitGameModeService

	def initialize(params)
		@player_stats = params[:player_stats]
		@lineups = params[:lineup_stats]
		@team_id = params[:team_id]
		@game_id = params[:game_id]
		@game_id = @game_id.to_i
		game = Game.find_by_id(@game_id)
		## TODO: CHECK TO MAKE SURE THIS WORKS!!!
		#game.game_state = nil;
		@team_stats = params[:team_stats]
		@opponent_obj = params[:opponent_stats]
		@opponent_stats =  @opponent_obj["cumulative_arr"]
		@opponent_granules = @opponent_obj["gran_stat_arr"]
		@opponent_id = @opponent_obj["player_obj"]["id"]
		@team_id = params[:team_id]
		@minutes_p_q = params[:minutes_p_q]
		@bpm_sums = [0, 0]
		@season_bpm_sums = [0, 0]
		@all_bpms = []
		@season_id = params[:season_id]
	end


	def call
		create_team_stats()
		create_opponent_stats()
		create_advanced_team_stats()
		create_player_stats()
		create_lineup_stats()
		adjust_bpm()
	end

	private

	def create_team_stats()
		## create team cumulative totals for each stat
		@team_stats.each do |stat|
			stat_total = StatTotal.create(
				value: stat[1]["total"],
				stat_list_id: stat[1]["id"],
				game_id: @game_id,
				team_id: @team_id,
				is_opponent: false,
				season_id: @season_id
			)

			season_total = TeamSeasonStat.where(team_id: @team_id, stat_list_id: stat[1]["id"], is_opponent: false, season_id: @season_id).select(:value).take

			if season_total 
				season_total.value += stat_total.value
				season_total.save
			else 
				season_total = TeamSeasonStat.create({
					value: stat_total.value,
					stat_list_id: stat[1]["id"],
					team_id: @team_id,
					is_opponent: false,
					season_id: @season_id
				})
			end
			if stat[1]["id"] == "16"
				@season_team_minutes = season_total.value
			end
			instantiate_stat_variable(stat_total, true, false, false, false)
			instantiate_stat_variable(season_total, true, false, false, true)
		end
	end

	def create_opponent_stats()
		@opponent_stats.each do |stat|
			stat_total = StatTotal.create(
				value: stat[1]["total"],
				stat_list_id: stat[1]["id"],
				game_id: @game_id,
				team_id: @team_id,
				is_opponent: true,
				season_id: @season_id
			)
			season_total = TeamSeasonStat.where(team_id: @team_id, stat_list_id: stat[1]["id"], is_opponent: true, season_id: @season_id).select(:value).take

			if season_total 
				season_total.value += stat_total.value
				season_total.save
			else 
				season_total = TeamSeasonStat.create({
					value: stat_total.value,
					stat_list_id: stat[1]["id"],
					team_id: @team_id,
					is_opponent: true,
					season_id: @season_id
				})
			end			
			instantiate_stat_variable(stat_total, true, true, false, false)
			instantiate_stat_variable(season_total, true, true, false, true)
		end
		@opponent_granules.each do |granule|
			metadata = granule[1]["metadata"]
			stat_list_id = granule[1]["stat"]
			stat_gran = OpponentGranule.create({
				metadata: metadata,
				opponent_id: @opponent_id,
				game_id: @game_id,
				stat_list_id: stat_list_id.to_i,
				season_id: @season_id,
			})
		end
	end

	def create_advanced_team_stats()
		## create team advanced stats 
		team_adv_stats = Stats::Advanced::Team::TeamAdvancedStatsService.new({
			team_field_goals: @team_field_goals,
			opp_field_goals: @opp_field_goals,
			team_field_goal_misses: @team_field_goal_misses,
			opp_field_goal_misses: @opp_field_goal_misses,
			team_off_reb: @team_off_reb,
			opp_off_reb: @opp_off_reb,
			team_turnovers: @team_turnovers,
			opp_turnovers: @opp_turnovers,
			team_free_throw_makes: @team_free_throw_makes,
			opp_free_throw_makes: @opp_free_throw_makes,
			team_free_throw_misses: @team_free_throw_misses,
			opp_free_throw_misses: @team_free_throw_misses,
			team_points: @team_points,
			opp_points: @opp_points,
			game_id: @game_id,
			team_id: @team_id,
			minutes_p_q: @minutes_p_q,
			team_minutes: @team_minutes,
			team_season_minutes: @season_team_minutes,
			team_three_point_makes: @team_three_point_fg,
			team_three_point_misses: @team_three_point_miss,
			opp_def_reb: @opp_def_reb,
			team_def_reb: @team_def_reb,
			opp_three_point_makes: @opp_three_point_fg,
			season_id: @season_id
		}).call

		## TODO: Rethink this -- using this return variable seems weird. I think its okay for now. 
		## Consider changing at a later point. 
		@possessions = team_adv_stats["possessions"]
		@opp_possessions = team_adv_stats["opp_possessions"]

		@defensive_efficiency = team_adv_stats["defensive_efficiency"]
		@offensive_efficiency = team_adv_stats["offensive_efficiency"]

		@season_offensive_efficiency = team_adv_stats["season_offensive_efficiency"]
		@season_defensive_efficiency = team_adv_stats["season_defensive_efficiency"]

		if(@offensive_efficiency != nil && @defensive_efficiency != nil)
			@season_team_rating = @season_offensive_efficiency - @season_defensive_efficiency
			@team_rating = @offensive_efficiency - @defensive_efficiency
		end
	end

	def create_lineup_stats()
		@lineups.each do |lineup|
			lineup_stats = lineup[1]["cumulative_arr"]
			lineup_opponent_stats = lineup[1]["opponent_stats"]
			lineup_player_ids = lineup[1]["ids"]
			lineup_obj = FindLineupService.new(ids: lineup_player_ids, season_id: @season_id).call()
			if(lineup_obj == nil)
				lineup_obj = Lineup.create(team_id: @team_id, season_id: @season_id)
				lineup_player_ids.each do |member_id|
					member = Member.find_by_id(member_id)
					lineup_obj.members << member
				end
			end
			lineup_stats.each do |stat|
				stat_id = stat[1]["id"]


				stat_total = stat[1]["total"]
				stat_id = stat_id.to_i
				stat_total = stat_total.to_i

				LineupGameStat.create({
					value: stat_total,
					stat_list_id: stat_id,
					lineup_id: lineup_obj.id,
					is_opponent: false,
					game_id: @game_id,
					season_id: @season_id
				})

				season_stat = LineupStat.where(lineup_id: lineup_obj.id, stat_list_id: stat_id, is_opponent: false, season_id: @season_id).select(:value).take

				if season_stat 
					season_stat.value += stat_total
					season_stat.save
				else 
					season_stat = LineupStat.create({
						value: stat_total,
						stat_list_id: stat_id,
						lineup_id: lineup_obj.id,
						is_opponent: false,
						season_id: @season_id
					})
				end
				if stat_id == 16
					lineup_obj.season_minutes = season_stat.value
					lineup_obj.save
					@lineup_minutes = season_stat.value
				end
				instantiate_stat_variable(season_stat, false, false, true, false)
			end

			lineup_opponent_stats.each do |stat|
				stat_id = stat[1]["id"]

				stat_total = stat[1]["total"]
				stat_id = stat_id.to_i
				stat_total = stat_total.to_i

				LineupGameStat.create({
					value: stat_total,
					stat_list_id: stat_id,
					lineup_id: lineup_obj.id,
					is_opponent: true,
					game_id: @game_id,
					season_id: @season_id
				})

				season_stat = LineupStat.where(lineup_id: lineup_obj.id, stat_list_id: stat_id, is_opponent: true, season_id: @season_id).select(:value).take

				if season_stat 
					season_stat.value += stat_total
					season_stat.save
				else 
					season_stat = LineupStat.create({
						value: stat_total,
						stat_list_id: stat_id,
						lineup_id: lineup_obj.id,
						is_opponent: true,
						season_id: @season_id
					})
				end
				instantiate_stat_variable(season_stat, false, true, true, false)
			end

			Stats::Lineups::LineupAdvancedService.new({
				field_goal_att: @lineup_field_goals + @lineup_field_goal_misses,
				free_throw_att: @lineup_free_throw_makes + @lineup_free_throw_misses,
				turnovers: @lineup_turnovers,
				off_reb: @lineup_off_reb,
				def_reb: @lineup_def_reb,
				field_goals: @lineup_field_goals,
				points: @lineup_points,
				three_point_fg: @lineup_three_point_fg,
				assists: @lineup_assists,


				opp_field_goal_att:  @lineup_opp_field_goals + @lineup_opp_field_goal_misses,
				opp_free_throw_att:  @lineup_opp_free_throw_makes + @lineup_opp_free_throw_misses,
				opp_turnovers:  @lineup_opp_turnovers,
				opp_off_reb:  @lineup_opp_off_reb,
				opp_def_reb:  @lineup_opp_def_reb,
				opp_points:  @lineup_opp_points,
				lineup_id: lineup_obj.id,
				team_id: @team_id,
				game_id: @game_id,
				season_id: @season_id
			}).call

			Stats::Lineups::LineupShootingStatsService.new({
				field_goals: @lineup_field_goals,
				field_goal_att: @lineup_field_goals + @lineup_field_goal_misses,
				free_throw_makes: @lineup_free_throw_makes,
				free_throw_att: @lineup_free_throw_makes + @lineup_free_throw_misses,
				three_point_fg: @lineup_three_point_fg,
				three_point_att: @lineup_three_point_fg + @lineup_three_point_miss,
				lineup_id: lineup_obj.id,
				season_id: @season_id
			}).call

		end
	end



	def create_player_stats()
		@player_stats.each do |stat|
			player_id = stat[1]["player_obj"]["id"]
			granule_arr = stat[1]["gran_stat_arr"]
			player_id = player_id.to_i

			cumulative_arr = stat[1]["cumulative_arr"]
			if granule_arr 
				granule_arr.each do |granule|
					metadata = granule[1]["metadata"]
					stat_list_id = granule[1]["stat"]
					stat_gran = StatGranule.create({
						metadata: metadata,
						member_id: player_id.to_i,
						game_id: @game_id,
						stat_list_id: stat_list_id.to_i,
						season_id: @season_id,
					})
					puts stat_gran.errors.full_messages
				end
			end
			if cumulative_arr 
				player = Member.find_by_id(player_id)
				

				counter = 0
				cumulative_arr.each do |cumulative_stat|
					stat_id = cumulative_stat[1]["id"]
					stat_total = cumulative_stat[1]["total"]
					stat_id = stat_id.to_i
					stat_total = stat_total.to_i
					cumulative_stat = Stat.create({
						value: stat_total,
						game_id: @game_id,
						stat_list_id: stat_id,
						member_id: player_id,
						season_id: @season_id
					})

					season_total = SeasonStat.where(member_id: player_id, stat_list_id: stat_id, season_id: @season_id).select(:value).take

					if season_total 
						season_total.value += stat_total
						season_total.save
					else 
						season_total = SeasonStat.create({
							value: stat_total,
							stat_list_id: stat_id,
							member_id: player_id,
							season_id: @season_id
						})
					end

					if stat_id == 16
						@season_minutes = season_total.value / 60.0
						if stat_total > 0
							player.games_played +=1
						end
					elsif stat_id == 1
						@season_makes = season_total.value
					elsif stat_id == 2 
						@season_misses = season_total.value
					elsif stat_id == 11 
						@season_three_point_makes = season_total.value
					elsif stat_id == 12 
						@season_three_point_misses = season_total.value
					elsif stat_id == 13
						@season_free_throw_makes = season_total.value
					elsif stat_id == 14 
						@season_free_throw_misses = season_total.value
					end
					instantiate_stat_variable(cumulative_stat, false, false, false, false)
				end

				player.season_minutes = @season_minutes *60.0
				player.save

				Stats::ShootingStatsService.new({
					field_goals: @field_goals,
					field_goal_att: @field_goals + @field_goal_misses,
					season_field_goals: @season_makes,
					season_field_goal_att: @season_makes + @season_misses,
					free_throw_makes: @free_throw_makes,
					free_throw_att: @free_throw_makes + @free_throw_misses,
					season_free_throw_makes: @season_free_throw_makes,
					season_free_throw_att: @season_free_throw_makes + @season_free_throw_misses,
					three_point_fg: @three_point_fg,
					three_point_att: @three_point_fg + @three_point_miss,
					season_three_point_fg: @season_three_point_makes,
					season_three_point_att: @season_three_point_makes + @season_three_point_misses,
					game_id: @game_id,
					member_id: player_id,
					season_id: @season_id
				}).call

				bpms = Stats::Advanced::AdvancedStatsService.new({
					field_goals: @field_goals,
					team_field_goals: @team_field_goals,
					opp_field_goals: @opp_field_goals,
					field_goal_misses: @field_goal_misses,
					team_field_goal_misses: @team_field_goal_misses,
					opp_field_goal_misses: @opp_field_goal_misses,
					assists: @assists,
					team_assists: @team_assists,
					opp_assists: @opp_assists,
					off_reb: @off_reb,
					team_off_reb: @team_off_reb,
					opp_off_reb: @opp_off_reb,
					def_reb: @def_reb,
					team_def_reb: @team_def_reb,
					opp_def_reb: @opp_def_reb,
					steals: @steals,
					team_steals: @team_steals,
					opp_steals: @opp_steals,
					turnovers: @turnovers,
					team_turnovers: @team_turnovers,
					opp_turnovers: @opp_turnovers,
					blocks: @blocks,
					team_blocks: @team_blocks,
					opp_blocks: @opp_blocks,
					three_point_fg: @three_point_fg,
					team_three_point_fg: @team_three_point_fg,
					opp_three_point_fg: @opp_three_point_fg,
					three_point_miss: @three_point_miss,
					team_three_point_miss: @team_three_point_miss,
					opp_three_point_miss: @opp_three_point_miss,
					free_throw_makes: @free_throw_makes,
					team_free_throw_makes: @team_free_throw_makes,
					opp_free_throw_makes: @opp_free_throw_makes,
					free_throw_misses: @free_throw_misses,
					team_free_throw_misses: @team_free_throw_misses,
					opp_free_throw_misses: @opp_free_throw_misses,
					points: @points,
					team_points: @team_points,
					opp_points: @opp_points,
					minutes: @minutes,
					team_minutes: @team_minutes,
					opp_minutes: @team_minutes,
					fouls: @fouls,
					team_fouls: @team_fouls,
					opp_fouls: @opp_fouls,
					possessions: @possessions,
					opp_possessions: @opp_possessions,
					member_id: player_id.to_i,
					game_id: @game_id.to_i,
					team_id: @team_id.to_i,
					season_id: @season_id
				}).call

				if(bpms["obpm"])
					@bpm_sums[0] += bpms["obpm"] * (@minutes / (@team_minutes / 5))
					@bpm_sums[1] += bpms["bpm"]* (@minutes / (@team_minutes / 5))

					# @season_bpm_sums[0] += bpms["new_obpm"].value * (@season_minutes / (@season_team_minutes / 5))
					# @season_bpm_sums[1] += bpms["new_bpm"].value * (@season_minutes / (@season_team_minutes / 5))
					@all_bpms.push(bpms)
				end
			end
		end
	end

	## TODO: MOVE TO DIFFERENT SERVICE -- come back to later
	def adjust_bpm()
		@all_bpms.each do |bpm|
			bpm_team_adjustment = (@team_rating * 1.2 - @bpm_sums[1])/5
			new_bpm = bpm["bpm"] + bpm_team_adjustment
			new_bpm = new_bpm * 100 
			new_bpm = new_bpm.round / 100.0
			AdvancedStat.create({
				stat_list_id: 42,
				member_id: bpm["member_id"],
				game_id: @game_id,
				constituent_stats: {
					"team_adjustment" => bpm_team_adjustment,
					"raw_bpm" => bpm["bpm"]
				},
				value: bpm["bpm"],
				season_id: @season_id
			})

			obpm_team_adjustment = (@team_rating * 1.2 - @bpm_sums[1])/5
			new_obpm = bpm["obpm"] + obpm_team_adjustment
			new_obpm = new_obpm * 100
			new_obpm = new_obpm.round / 100.0
			AdvancedStat.create({
				stat_list_id: 40,
				member_id: bpm["member_id"],
				game_id: @game_id,
				constituent_stats: {
					"team_adjustment" => obpm_team_adjustment,
					"raw_bpm" => bpm["obpm"]
				},
				value: bpm["obpm"],
				season_id: @season_id
			})
			
			# bpm_season_adjustment = (@season_team_rating * 1.2 - @season_bpm_sums[1])/5

			# new_season_bpm = bpm["new_bpm"].value + bpm_season_adjustment
			# new_season_bpm = new_season_bpm * 100 
			# new_season_bpm = new_season_bpm.round / 100.0

			# season_stat = SeasonAdvancedStat.where(stat_list_id: 42, member_id: bpm["member_id"], season_id: @season_id).take
			# if season_stat
			# 	season_stat.value = bpm["new_bpm"].value
			# 	season_stat.constituent_stats = {
			# 		"team_adjustment" => bpm_season_adjustment,
			# 		"raw_bpm" => bpm["new_bpm"].value
			# 	}
			# 	season_stat.save
			# else
			# 	SeasonAdvancedStat.create({
			# 		stat_list_id: 42,
			# 		member_id: bpm["member_id"],
			# 		constituent_stats: {
			# 			"team_adjustment" => bpm_season_adjustment,
			# 			"raw_bpm" =>  bpm["new_bpm"].value
			# 		},
			# 		value: bpm["new_bpm"].value,
			# 		season_id: @season_id
			# 	})
			# end

			# obpm_season_adjustment = (@season_team_rating * 1.2 - @season_bpm_sums[1])/5
			# new_season_obpm = bpm["new_obpm"].value + obpm_season_adjustment
			# new_season_obpm = new_season_obpm * 100
			# new_season_obpm = new_season_obpm.round / 100.0

			# season_stat = SeasonAdvancedStat.where(stat_list_id: 40, member_id: bpm["member_id"], season_id: @season_id).take
			# if season_stat
			# 	season_stat.value = new_season_obpm
			# 	season_stat.constituent_stats = {
			# 		"team_adjustment" => obpm_season_adjustment,
			# 		"raw_bpm" => bpm["new_obpm"].value
			# 	}
			# 	season_stat.save
			# else
			# 	SeasonAdvancedStat.create({
			# 		stat_list_id: 40,
			# 		member_id: bpm["member_id"],
			# 		constituent_stats: {
			# 			"team_adjustment" => obpm_season_adjustment,
			# 			"raw_bpm" =>  bpm["new_obpm"].value
			# 		},
			# 		value: bpm["new_obpm"].value,
			# 		season_id: @season_id
			# 	})
			# end

		end
	end


	def instantiate_stat_variable(stat, is_team, is_opponent, is_lineup, is_season)
		case stat.stat_list_id

		when 1
			if !is_team
				if is_lineup
					if is_opponent
						@lineup_opp_field_goals = stat.value
					else
						@lineup_field_goals = stat.value
					end
				else
					@field_goals = stat.value
				end
			else
				if is_opponent
					if is_season
						@season_opp_field_goals = stat.value
					else
						@opp_field_goals = stat.value
					end
				else
					if is_season
						@season_team_field_goals = stat.value
					else
						@team_field_goals = stat.value
					end
				end
			end
		when 2
			if !is_team
				if is_lineup
					if is_opponent
						@lineup_opp_field_goal_misses = stat.value
					else
						@lineup_field_goal_misses = stat.value
					end
				else
					@field_goal_misses = stat.value
				end
			else
				if is_opponent
					if is_season
						@season_opp_field_goal_misses = stat.value
					else
						@opp_field_goal_misses = stat.value
					end
				else
					if is_season
						@season_team_field_goal_misses = stat.value
					else
						@team_field_goal_misses = stat.value
					end
				end
			end
		when 3
			if !is_team
				if is_lineup
					if is_opponent
						@lineup_opp_assists = stat.value
					else
						@lineup_assists = stat.value
					end
				else
					@assists = stat.value
				end
			else
				if is_opponent
					if is_season
						@season_opp_assists = stat.value
					else
						@opp_assists = stat.value
					end
				else
					if is_season
						@season_team_assists = stat.value
					else
						@team_assists = stat.value
					end
				end
			end
		when 4
			if !is_team
				if is_lineup
					if is_opponent
						@lineup_opp_off_reb = stat.value
					else
						@lineup_off_reb = stat.value
					end
				else
					@off_reb = stat.value
				end
			else
				if is_opponent
					if is_season
						@season_opp_off_reb = stat.value
					else
						@opp_off_reb = stat.value
					end
				else
					if is_season
						@season_team_off_reb = stat.value
					else
						@team_off_reb = stat.value
					end
				end
			end
		when 5
			if !is_team
				if is_lineup
					if is_opponent
						@lineup_opp_def_reb = stat.value
					else
						@lineup_def_reb = stat.value
					end
				else
					@def_reb = stat.value
				end
			else
				if is_opponent
					if is_season
						@season_opp_def_reb = stat.value
					else
						@opp_def_reb = stat.value
					end
				else
					if is_season
						@season_team_def_reb = stat.value
					else
						@team_def_reb = stat.value
					end
				end
			end
		when 6
			if !is_team
				if is_lineup
					if is_opponent
						@lineup_opp_steals = stat.value
					else
						@lineup_steals = stat.value
					end
				else
					@steals = stat.value
				end
			else
				if is_opponent
					if is_season
						@season_opp_steals = stat.value
					else
						@opp_steals = stat.value
					end
				else
					if is_season
						@season_team_steals = stat.value
					else
						@team_steals = stat.value
					end
				end
			end
		when 7
			if !is_team
				if is_lineup
					if is_opponent
						@lineup_opp_turnovers = stat.value
					else
						@lineup_turnovers = stat.value
					end
				else
					@turnovers = stat.value
				end
			else
				if is_opponent
					if is_season
						@season_opp_turnovers = stat.value
					else
						@opp_turnovers = stat.value
					end
				else
					if is_season
						@season_team_turnovers = stat.value
					else
						@team_turnovers = stat.value
					end
				end
			end
		when 8
			if !is_team
				if is_lineup
					if is_opponent
						@lineup_opp_blocks = stat.value
					else
						@lineup_blocks = stat.value
					end
				else
					@blocks = stat.value
				end
			else
				if is_opponent
					if is_season
						@season_opp_blocks = stat.value
					else
						@opp_blocks = stat.value
					end
				else
					if is_season
						@season_team_blocks = stat.value
					else
						@team_blocks = stat.value
					end
				end
			end
		when 11
			if !is_team
				if is_lineup
					if is_opponent
						@lineup_opp_three_point_fg = stat.value
					else
						@lineup_three_point_fg = stat.value
					end
				else
					@three_point_fg = stat.value
				end
			else
				if is_opponent
					if is_season
						@season_opp_three_point_fg = stat.value
					else
						@opp_three_point_fg = stat.value
					end
				else
					if is_season
						@season_team_three_point_fg = stat.value
					else
						@team_three_point_fg = stat.value
					end
				end
			end
		when 12
			if !is_team
				if is_lineup
					if is_opponent
						@lineup_opp_three_point_miss = stat.value
					else
						@lineup_three_point_miss = stat.value
					end
				else
					@three_point_miss = stat.value
				end
			else
				if is_opponent
					if is_season
						@season_opp_three_point_miss = stat.value
					else
						@opp_three_point_miss = stat.value
					end
				else
					if is_season
						@season_team_three_point_miss = stat.value
					else
						@team_three_point_miss = stat.value
					end
				end
			end
		when 13
			if !is_team
				if is_lineup
					if is_opponent
						@lineup_opp_free_throw_makes = stat.value
					else
						@lineup_free_throw_makes = stat.value
					end
				else
					@free_throw_makes = stat.value
				end
			else
				if is_opponent
					if is_season
						@season_opp_free_throw_makes = stat.value
					else
						@opp_free_throw_makes = stat.value
					end
				else
					if is_season
						@season_team_free_throw_makes = stat.value
					else
						@team_free_throw_makes = stat.value
					end
				end
			end
		when 14
			if !is_team
				if is_lineup
					if is_opponent
						@lineup_opp_free_throw_misses = stat.value
					else
						@lineup_free_throw_misses = stat.value
					end
				else
					@free_throw_misses = stat.value
				end
			else
				if is_opponent
					if is_season
						@season_opp_free_throw_misses = stat.value
					else
						@opp_free_throw_misses = stat.value
					end
				else
					if is_season
						@season_team_free_throw_misses = stat.value
					else
						@team_free_throw_misses = stat.value
					end
				end
			end
		when 15
			if !is_team
				if is_lineup
					if is_opponent
						@lineup_opp_points = stat.value
					else
						@lineup_points = stat.value
					end
				else
					@points = stat.value
				end
			else
				if is_opponent
					if is_season
						@season_opp_points = stat.value
					else
						@opp_points = stat.value
					end
				else
					if is_season
						@season_team_points = stat.value
					else
						@team_points = stat.value
					end
				end
			end
		when 16
			if !is_team
				if is_lineup
					@lineup_minutes = stat.value / 60.0
				else
					@minutes = stat.value / 60.0
				end
			else
				if !is_opponent
					if is_season
						@season_team_minutes = stat.value / 60.0
					else
						@team_minutes = stat.value / 60.0
					end
				end
			end
		when 17
			if !is_team
				if is_lineup
					if is_opponent 
						@lineup_opp_fouls = stat.value
					else
						@lineup_fouls = stat.value
					end
				else
					@fouls = stat.value
				end
			else
				if is_opponent
					if is_season
						@season_opp_fouls = stat.value
					else
						@opp_fouls = stat.value
					end
				else
					if is_season
						@season_team_fouls = stat.value
					else
						@team_fouls = stat.value
					end
				end
			end
		end
	end



end
