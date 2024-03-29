

class Stats::Advanced::AdvancedStatsService

	def initialize(params)
		@field_goals = params[:field_goals].to_f
		@team_field_goals = params[:team_field_goals].to_f 
		@opp_field_goals =params[:opp_field_goals].to_f
		@field_goal_misses =params[:field_goal_misses].to_f
		@team_field_goal_misses = params[:team_field_goal_misses].to_f
		@opp_field_goal_misses = params[:opp_field_goal_misses].to_f 
		@assists = params[:assists].to_f 
		@team_assists = params[:team_assists].to_f
		@opp_assists = params[:opp_assists].to_f 
		@off_reb = params[:off_reb].to_f 
		@team_off_reb = params[:team_off_reb].to_f 
		@opp_off_reb = params[:opp_off_reb].to_f 
		@def_reb = params[:def_reb].to_f 
		@team_def_reb = params[:team_def_reb].to_f 
		@opp_def_reb = params[:opp_def_reb].to_f 
		@steals = params[:steals].to_f
		@team_steals = params[:team_steals].to_f 
		@opp_steals = params[:opp_steals].to_f 
		@turnovers = params[:turnovers].to_f 
		@team_turnovers = params[:team_turnovers].to_f 
		@opp_turnovers = params[:opp_turnovers].to_f 
		@blocks = params[:blocks].to_f 
		@team_blocks = params[:team_blocks].to_f 
		@opp_blocks = params[:opp_blocks].to_f 
		@three_point_fg = params[:three_point_fg].to_f 
		@team_three_point_fg = params[:team_three_point_fg].to_f 
		@opp_three_point_fg = params[:opp_three_point_fg].to_f 
		@three_point_miss = params[:three_point_miss].to_f 
		@team_three_point_miss = params[:team_three_point_miss].to_f 
		@opp_three_point_miss = params[:opp_three_point_miss].to_f 
		@free_throw_makes = params[:free_throw_makes].to_f 
		@team_free_throw_makes = params[:team_free_throw_makes].to_f 
		@opp_free_throw_makes = params[:opp_free_throw_makes].to_f 
		@free_throw_misses = params[:free_throw_misses].to_f 
		@team_free_throw_misses = params[:team_free_throw_misses].to_f 
		@opp_free_throw_misses = params[:opp_free_throw_misses].to_f 
		@points = params[:points].to_f 
		@team_points = params[:team_points].to_f 
		@opp_points = params[:opp_points].to_f 
		@minutes = params[:minutes].to_f 
		@team_minutes = params[:team_minutes].to_f

		@opp_minutes =  params[:team_minutes].to_f 
		@fouls = params[:fouls].to_f 
		@team_fouls = params[:team_fouls].to_f 
		@opp_fouls = params[:opp_fouls].to_f 


		@member_id = params[:member_id]
		@game_id = params[:game_id]
		@team_id = params[:team_id]
		@season_id = params[:season_id]


		@possessions = params[:possessions]
		@opp_possessions = params[:opp_possessions]

		@total_reb = @off_reb + @def_reb
		@team_total_reb = @team_off_reb + @team_def_reb
		@opp_total_reb = @opp_def_reb + @team_off_reb

		@field_goal_att = @field_goals + @field_goal_misses
		@team_field_goal_att = @team_field_goals + @team_field_goal_misses
		@opp_field_goal_att = @opp_field_goals + @opp_field_goal_misses
		@free_throw_att = @free_throw_makes + @free_throw_misses
		@team_free_throw_att = @team_free_throw_makes + @team_free_throw_misses
		@opp_free_throw_att = @opp_free_throw_makes + @opp_free_throw_misses
		@three_point_att = @three_point_fg + @three_point_miss
		@team_three_point_att = @team_three_point_fg + @team_three_point_miss
		@opp_three_point_att = @opp_three_point_fg + @opp_three_point_miss
		@create_hash = []

	end

	def call
		advanced_stats = TeamStat.joins(:stat_list).select("stat_lists.advanced as advanced, team_stats.*").where("stat_lists.advanced" => true, "team_stats.team_id" => @team_id).sort_by{|e| e.stat_list_id}

		advanced_stats.each do |stat|
			case stat.stat_list_id
			when 18 
				effective_fg_pct()
			when 19
				true_shooting()
			when 20 
				linear_per()
			when 21 
				three_pt_attempt_rate()
			when 22
				free_throw_att_rate()
			when 23
				usage_rate()
			when 24
				offensive_rating()
			when 25
				defensive_rating()
			when 26
				net_rating()
			when 33
				offensive_rb_pct()
			when 34
				defensive_reb_pct()
			when 35
				total_reb_pct()
			when 36
				steal_pct()
			when 37
				block_pct()
			when 38
				turnover_pct()
			when 39
				assist_pct()
			when 42
				box_plus_minus()
				off_box_plus_minus()
				def_box_plus_minus()
			end		
		end

		create_stats()

		puts "OBPM"
		puts @obpm

		## return box plus minus values to adjust later
		return {"obpm" => @off_box_plus_minus, "bpm" => @box_plus_minus , "member_id" => @member_id}
	end

	private 

	def steal_pct()

		steal_pct = Stats::Advanced::Player::StealPctService.new({
			steals: @steals,
			team_minutes: @team_minutes,
			minutes: @minutes,
			opp_poss: @opp_possessions
		}).call
		
		@create_hash.push({
			stat_list_id: 36,
			member_id: @member_id,
			game_id: @game_id,
			constituent_stats: {
				"steals" => @steals,
				"team_minutes" => @team_minutes,
				"minutes" => @minutes,
				"opp_poss" => @opp_possessions,
			},
			value: steal_pct,
			season_id: @season_id
		})

		# AdvancedStat.create({
		# 	stat_list_id: 36,
		# 	member_id: @member_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"steals" => @steals,
		# 		"team_minutes" => @team_minutes,
		# 		"minutes" => @minutes,
		# 		"opp_poss" => @opp_possessions,
		# 	},
		# 	value: steal_pct,
		# 	season_id: @season_id
		# })

		# season_stat = SeasonAdvancedStat.where(stat_list_id: 36, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	new_steal_pct = Stats::Advanced::Player::StealPctService.new({
		# 		steals: @steals + season_stat.constituent_stats["steals"],
		# 		team_minutes: @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		minutes: @minutes + season_stat.constituent_stats["minutes"],
		# 		opp_poss: @opp_possessions + season_stat.constituent_stats["opp_poss"]
		# 	}).call

		# 	season_stat.value = new_steal_pct
		# 	season_stat.constituent_stats = {
		# 		"steals" => @steals + season_stat.constituent_stats["steals"],
		# 		"team_minutes" => @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		"minutes" => @minutes + season_stat.constituent_stats["minutes"],
		# 		"opp_poss" => @opp_possessions + season_stat.constituent_stats["opp_poss"],
		# 	}
		# 	season_stat.save
		# else

		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 36,
		# 		member_id: @member_id,
		# 		constituent_stats: {
		# 			"steals" => @steals,
		# 			"team_minutes" => @team_minutes,
		# 			"minutes" => @minutes,
		# 			"opp_poss" => @opp_possessions,
		# 		},
		# 		value: steal_pct,
		# 		season_id: @season_id
		# 	})
		# end
	end

	def turnover_pct()
		## CORRECT
		turnover_pct = Stats::Advanced::Player::TurnoverPctService.new({
			turnovers: @turnovers,
			field_goal_att: @field_goal_att,
			free_throw_att: @free_throw_att,
		}).call
		
		@create_hash.push({
			stat_list_id: 38,
			member_id: @member_id,
			game_id: @game_id,
			constituent_stats: {
				"turnovers" => @turnovers,
				"field_goal_att" => @field_goal_att,
				"free_throw_att" => @free_throw_att,
			},
			value: turnover_pct,
			season_id: @season_id
		})
		# AdvancedStat.create({
		# 	stat_list_id: 38,
		# 	member_id: @member_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"turnovers" => @turnovers,
		# 		"field_goal_att" => @field_goal_att,
		# 		"free_throw_att" => @free_throw_att,
		# 	},
		# 	value: turnover_pct,
		# 	season_id: @season_id
		# })


		# season_stat = SeasonAdvancedStat.where(stat_list_id: 38, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	new_tov_pct = Stats::Advanced::Player::TurnoverPctService.new({
		# 		turnovers: @turnovers + season_stat.constituent_stats["turnovers"],
		# 		field_goal_att: @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 		free_throw_att: @free_throw_att + season_stat.constituent_stats["free_throw_att"],
		# 	}).call

		# 	season_stat.value = new_tov_pct
		# 	season_stat.constituent_stats = {
		# 		"turnovers" => @turnovers + season_stat.constituent_stats["turnovers"],
		# 		"field_goal_att" => @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 		"free_throw_att" => @free_throw_att + season_stat.constituent_stats["free_throw_att"],
		# 	}
		# 	season_stat.save
		# else
			
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 38,
		# 		member_id: @member_id,
		# 		constituent_stats: {
		# 			"turnovers" => @turnovers,
		# 			"field_goal_att" => @field_goal_att,
		# 			"free_throw_att" => @free_throw_att,
		# 		},
		# 		value: turnover_pct,
		# 		season_id: @season_id
		# 	})
		# end
	end

	def offensive_rb_pct()
		## CORRECT
		offensive_rebound_pct = Stats::Advanced::Player::OffensiveReboundPctService.new({
			off_reb: @off_reb,
			opp_def_reb: @opp_def_reb,
			team_minutes: @team_minutes,
			minutes: @minutes,
			team_off_reb: @team_off_reb
		}).call

		@create_hash.push({
			stat_list_id: 33,
			member_id: @member_id,
			game_id: @game_id,
			constituent_stats: {
				"off_reb" => @off_reb,
				"opp_def_reb" => @opp_def_reb,
				"team_minutes" => @team_minutes,
				"minutes" => @minutes,
				"team_off_reb" => @team_off_reb
			},
			value: offensive_rebound_pct,
			season_id: @season_id
		})

		# AdvancedStat.create({
		# 	stat_list_id: 33,
		# 	member_id: @member_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"off_reb" => @off_reb,
		# 		"opp_def_reb" => @opp_def_reb,
		# 		"team_minutes" => @team_minutes,
		# 		"minutes" => @minutes,
		# 		"team_off_reb" => @team_off_reb
		# 	},
		# 	value: offensive_rebound_pct,
		# 	season_id: @season_id
		# })


		# season_stat = SeasonAdvancedStat.where(stat_list_id: 33, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	new_oreb_pct = Stats::Advanced::Player::OffensiveReboundPctService.new({
		# 		off_reb: @off_reb + season_stat.constituent_stats["off_reb"],
		# 		opp_def_reb: @opp_def_reb + season_stat.constituent_stats["opp_def_reb"],
		# 		team_minutes: @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		minutes: @minutes + season_stat.constituent_stats["minutes"],
		# 		team_off_reb: @team_off_reb + season_stat.constituent_stats["team_off_reb"],
		# 	}).call

		# 	season_stat.value = new_oreb_pct
		# 	season_stat.constituent_stats = {
		# 		"off_reb" => @off_reb + season_stat.constituent_stats["off_reb"],
		# 		"opp_def_reb" => @opp_def_reb + season_stat.constituent_stats["opp_def_reb"],
		# 		"team_minutes" => @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		"minutes" => @minutes + season_stat.constituent_stats["minutes"],
		# 		"team_off_reb" => @team_off_reb + season_stat.constituent_stats["team_off_reb"],
		# 	}
		# 	season_stat.save
		# else
			
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 33,
		# 		member_id: @member_id,
		# 		constituent_stats: {
		# 			"off_reb" => @off_reb,
		# 			"opp_def_reb" => @opp_def_reb,
		# 			"team_minutes" => @team_minutes,
		# 			"minutes" => @minutes,
		# 			"team_off_reb" => @team_off_reb
		# 		},
		# 		value: offensive_rebound_pct,
		# 		season_id: @season_id
		# 	})
		# end
	end

	def block_pct()
		## CORRECT
		block_pct = Stats::Advanced::Player::BlockPctService.new({
			blocks: @blocks,
			team_minutes: @team_minutes,
			minutes: @minutes,
			opp_field_goal_att: @opp_field_goal_att,
			opp_three_point_att: @opp_three_point_att,
		}).call

		@create_hash.push({
			stat_list_id: 37,
			member_id: @member_id,
			game_id: @game_id,
			constituent_stats: {
				"blocks" => @blocks,
				"team_minutes" => @team_minutes,
				"minutes" => @minutes,
				"opp_field_goal_att" => @opp_field_goal_att,
				"opp_three_point_att" => @opp_three_point_att,
			},
			value: block_pct,
			season_id: @season_id
		})

		# AdvancedStat.create({
		# 	stat_list_id: 37,
		# 	member_id: @member_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"blocks" => @blocks,
		# 		"team_minutes" => @team_minutes,
		# 		"minutes" => @minutes,
		# 		"opp_field_goal_att" => @opp_field_goal_att,
		# 		"opp_three_point_att" => @opp_three_point_att,
		# 	},
		# 	value: block_pct,
		# 	season_id: @season_id
		# })


		# season_stat = SeasonAdvancedStat.where(stat_list_id: 37, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	new_block_pct = Stats::Advanced::Player::BlockPctService.new({
		# 		blocks: @blocks + season_stat.constituent_stats["blocks"],
		# 		team_minutes: @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		minutes: @minutes + season_stat.constituent_stats["minutes"],
		# 		opp_field_goal_att: @opp_field_goal_att + season_stat.constituent_stats["opp_field_goal_att"],
		# 		opp_three_point_att: @opp_three_point_att + season_stat.constituent_stats["opp_three_point_att"],
		# 	}).call

		# 	season_stat.value = new_block_pct
		# 	season_stat.constituent_stats = {
		# 		"blocks" => @blocks + season_stat.constituent_stats["blocks"],
		# 		"team_minutes" => @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		"minutes" => @minutes + season_stat.constituent_stats["minutes"],
		# 		"opp_field_goal_att" => @opp_field_goal_att + season_stat.constituent_stats["opp_field_goal_att"],
		# 		"opp_three_point_att" => @opp_three_point_att + season_stat.constituent_stats["opp_three_point_att"],
		# 	}
		# 	season_stat.save
		# else
			
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 37,
		# 		member_id: @member_id,
		# 		constituent_stats: {
		# 			"blocks" => @blocks,
		# 			"team_minutes" => @team_minutes,
		# 			"minutes" => @minutes,
		# 			"opp_field_goal_att" => @opp_field_goal_att,
		# 			"opp_three_point_att" => @opp_three_point_att,
		# 		},
		# 		value: block_pct,
		# 		season_id: @season_id
		# 	})
		# end
	end

	def assist_pct()
		## CORRECT
		assist_pct = Stats::Advanced::Player::AssistPctService.new({
			assists: @assists,
			minutes: @minutes,
			team_minutes: @team_minutes,
			team_field_goals: @team_field_goals,
			field_goals: @field_goals,
		}).call

		@create_hash.push({
			stat_list_id: 39,
			member_id: @member_id,
			game_id: @game_id,
			constituent_stats: {
				"assists" => @assists,
				"minutes" => @minutes,
				"team_minutes" => @team_minutes,
				"team_field_goals" => @team_field_goals,
				"field_goals" => @field_goals,
			},
			value: assist_pct,
			season_id: @season_id
		})

		# AdvancedStat.create({
		# 	stat_list_id: 39,
		# 	member_id: @member_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"assists" => @assists,
		# 		"minutes" => @minutes,
		# 		"team_minutes" => @team_minutes,
		# 		"team_field_goals" => @team_field_goals,
		# 		"field_goals" => @field_goals,
		# 	},
		# 	value: assist_pct,
		# 	season_id: @season_id
		# })


		# season_stat = SeasonAdvancedStat.where(stat_list_id: 39, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	new_assist_pct = Stats::Advanced::Player::AssistPctService.new({
		# 		assists: @assists + season_stat.constituent_stats["assists"],
		# 		minutes: @minutes + season_stat.constituent_stats["minutes"],
		# 		team_minutes: @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		team_field_goals: @team_field_goals + season_stat.constituent_stats["team_field_goals"],
		# 		field_goals: @field_goals + season_stat.constituent_stats["field_goals"],
		# 	}).call

		# 	season_stat.value = new_assist_pct
		# 	season_stat.constituent_stats = {
		# 		"assists" => @assists + season_stat.constituent_stats["assists"],
		# 		"minutes" => @minutes + season_stat.constituent_stats["minutes"],
		# 		"team_minutes" => @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		"team_field_goals" => @team_field_goals + season_stat.constituent_stats["team_field_goals"],
		# 		"field_goals" => @field_goals + season_stat.constituent_stats["field_goals"],
		# 	}
		# 	season_stat.save
		# else
			
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 39,
		# 		member_id: @member_id,
		# 		constituent_stats: {
		# 			"assists" => @assists,
		# 			"minutes" => @minutes,
		# 			"team_minutes" => @team_minutes,
		# 			"team_field_goals" => @team_field_goals,
		# 			"field_goals" => @field_goals,
		# 		},
		# 		value: assist_pct,
		# 		season_id: @season_id
		# 	})
		# end
	end

	def usage_rate()
		## CORRECT
		usage_rate = Stats::Advanced::Player::UsageRateService.new({
			field_goal_att: @field_goal_att,
			turnovers: @turnovers,
			free_throw_att: @free_throw_att,
			team_minutes: @team_minutes,
			minutes: @minutes,
			team_field_goal_att: @team_field_goal_att,
			team_turnovers: @team_turnovers,
			team_free_throw_att: @team_free_throw_att,
		}).call

		@create_hash.push({
			stat_list_id: 23,
			member_id: @member_id,
			game_id: @game_id,
			constituent_stats: {
				"field_goal_att" => @field_goal_att,
				"turnovers" => @turnovers,
				"free_throw_att" => @free_throw_att,
				"team_minutes" => @team_minutes,
				"minutes" => @minutes,
				"team_field_goal_att" => @team_field_goal_att,
				"team_turnovers" => @team_turnovers,
				"team_free_throw_att" => @team_free_throw_att,
			},
			value: usage_rate,
			season_id: @season_id
		})

		# AdvancedStat.create({
		# 	stat_list_id: 23,
		# 	member_id: @member_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"field_goal_att" => @field_goal_att,
		# 		"turnovers" => @turnovers,
		# 		"free_throw_att" => @free_throw_att,
		# 		"team_minutes" => @team_minutes,
		# 		"minutes" => @minutes,
		# 		"team_field_goal_att" => @team_field_goal_att,
		# 		"team_turnovers" => @team_turnovers,
		# 		"team_free_throw_att" => @team_free_throw_att,
		# 	},
		# 	value: usage_rate,
		# 	season_id: @season_id
		# })

		# season_stat = SeasonAdvancedStat.where(stat_list_id: 23, member_id: @member_id,season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	new_usage_rate = Stats::Advanced::Player::UsageRateService.new({
		# 		field_goal_att: @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 		turnovers: @turnovers + season_stat.constituent_stats["turnovers"],
		# 		free_throw_att: @free_throw_att + season_stat.constituent_stats["free_throw_att"],
		# 		team_minutes: @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		minutes: @minutes + season_stat.constituent_stats["minutes"],
		# 		team_field_goal_att: @team_field_goal_att + season_stat.constituent_stats["team_field_goal_att"],
		# 		team_turnovers: @team_turnovers + season_stat.constituent_stats["team_turnovers"],
		# 		team_free_throw_att: @team_free_throw_att + season_stat.constituent_stats["team_free_throw_att"],
		# 	}).call

		# 	season_stat.value = new_usage_rate
		# 	season_stat.constituent_stats = {
		# 		"field_goal_att" => @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 		"turnovers" => @turnovers + season_stat.constituent_stats["turnovers"],
		# 		"free_throw_att" => @free_throw_att + season_stat.constituent_stats["free_throw_att"],
		# 		"team_minutes" => @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		"minutes" => @minutes + season_stat.constituent_stats["minutes"],
		# 		"team_field_goal_att" => @team_field_goal_att + season_stat.constituent_stats["team_field_goal_att"],
		# 		"team_turnovers" => @team_turnovers + season_stat.constituent_stats["team_turnovers"],
		# 		"team_free_throw_att" => @team_free_throw_att + season_stat.constituent_stats["team_free_throw_att"],
		# 	}
		# 	season_stat.save
		# else
			
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 23,
		# 		member_id: @member_id,
		# 		constituent_stats: {
		# 			"field_goal_att" => @field_goal_att,
		# 			"turnovers" => @turnovers,
		# 			"free_throw_att" => @free_throw_att,
		# 			"team_minutes" => @team_minutes,
		# 			"minutes" => @minutes,
		# 			"team_field_goal_att" => @team_field_goal_att,
		# 			"team_turnovers" => @team_turnovers,
		# 			"team_free_throw_att" => @team_free_throw_att,
		# 		},
		# 		value: usage_rate,
		# 		season_id: @season_id
		# 	})
		# end
	end

	def total_reb_pct()
		total_rebound_pct = Stats::Advanced::TotalReboundPctService.new({
			total_reb: @total_reb,
			team_minutes: @team_minutes,
			minutes: @minutes,
			team_total_reb: @team_total_reb,
			opp_total_reb: @opp_total_reb,
		}).call

		@create_hash.push({
			stat_list_id: 35,
			member_id: @member_id,
			game_id: @game_id,
			constituent_stats: {
				"total_reb" => @total_reb,
				"team_minutes" => @team_minutes,
				"minutes" => @minutes,
				"team_total_reb" => @team_total_reb,
				"opp_total_reb" =>  @opp_total_reb,
			},
			value: total_rebound_pct,
			season_id: @season_id
		})

		# AdvancedStat.create({
		# 	stat_list_id: 35,
		# 	member_id: @member_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"total_reb" => @total_reb,
		# 		"team_minutes" => @team_minutes,
		# 		"minutes" => @minutes,
		# 		"team_total_reb" => @team_total_reb,
		# 		"opp_total_reb" =>  @opp_total_reb,
		# 	},
		# 	value: total_rebound_pct,
		# 	season_id: @season_id
		# })

		# season_stat = SeasonAdvancedStat.where(stat_list_id: 35, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	new_treb_pct = Stats::Advanced::TotalReboundPctService.new({
		# 		total_reb: @total_reb + season_stat.constituent_stats["total_reb"],
		# 		team_minutes: @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		minutes: @minutes + season_stat.constituent_stats["minutes"],
		# 		team_total_reb: @team_total_reb + season_stat.constituent_stats["team_total_reb"],
		# 		opp_total_reb: @opp_total_reb + season_stat.constituent_stats["opp_total_reb"],
		# 	}).call

		# 	season_stat.value = new_treb_pct
		# 	season_stat.constituent_stats = {
		# 		"total_reb" => @total_reb + season_stat.constituent_stats["total_reb"],
		# 		"team_minutes" => @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		"minutes" => @minutes + season_stat.constituent_stats["minutes"],
		# 		"team_total_reb" => @team_total_reb + season_stat.constituent_stats["team_total_reb"],
		# 		"opp_total_reb" =>  @opp_total_reb + season_stat.constituent_stats["opp_total_reb"],
		# 	}
		# 	season_stat.save
		# else
			
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 35,
		# 		member_id: @member_id,
		# 		constituent_stats: {
		# 			"total_reb" => @total_reb,
		# 			"team_minutes" => @team_minutes,
		# 			"minutes" => @minutes,
		# 			"team_total_reb" => @team_total_reb,
		# 			"opp_total_reb" =>  @opp_total_reb,
		# 		},
		# 		value: total_rebound_pct,
		# 		season_id: @season_id
		# 	})
		# end
	end

	def defensive_reb_pct()
		## CORRECT
		defensive_rebound_pct = Stats::Advanced::Player::DefensiveReboundPctService.new({
			def_reb: @def_reb,
			opp_off_reb: @opp_off_reb,
			team_minutes: @team_minutes,
			minutes: @minutes,
			team_def_reb: @team_def_reb
		}).call

		@create_hash.push({
			stat_list_id: 34,
			member_id: @member_id,
			game_id: @game_id,
			constituent_stats: {
				"def_reb" => @def_reb,
				"opp_off_reb" => @opp_off_reb,
				"team_minutes" => @team_minutes,
				"minutes" => @minutes,
				"team_def_reb" => @team_def_reb,
			},
			value: defensive_rebound_pct,
			season_id: @season_id
		})

		# AdvancedStat.create({
		# 	stat_list_id: 34,
		# 	member_id: @member_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"def_reb" => @def_reb,
		# 		"opp_off_reb" => @opp_off_reb,
		# 		"team_minutes" => @team_minutes,
		# 		"minutes" => @minutes,
		# 		"team_def_reb" => @team_def_reb,
		# 	},
		# 	value: defensive_rebound_pct,
		# 	season_id: @season_id
		# })

		# season_stat = SeasonAdvancedStat.where(stat_list_id: 34, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	new_def_reb_pct = Stats::Advanced::Player::DefensiveReboundPctService.new({
		# 		def_reb: @def_reb + season_stat.constituent_stats["def_reb"],
		# 		opp_off_reb: @opp_off_reb + season_stat.constituent_stats["opp_off_reb"],
		# 		team_minutes: @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		minutes: @minutes + season_stat.constituent_stats["minutes"],
		# 		team_def_reb: @team_def_reb + season_stat.constituent_stats["team_def_reb"],
		# 	}).call

		# 	season_stat.value = new_def_reb_pct
		# 	season_stat.constituent_stats = {
		# 		"def_reb" => @def_reb + season_stat.constituent_stats["def_reb"],
		# 		"opp_off_reb" => @opp_off_reb + season_stat.constituent_stats["opp_off_reb"],
		# 		"team_minutes" => @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		"minutes" => @minutes + season_stat.constituent_stats["minutes"],
		# 		"team_def_reb" => @team_def_reb + @opp_off_reb + season_stat.constituent_stats["team_def_reb"],
		# 	}
		# 	season_stat.save
		# else
			
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 34,
		# 		member_id: @member_id, 
		# 		season_id: @season_id,
		# 		constituent_stats: {
		# 			"def_reb" => @def_reb,
		# 			"opp_off_reb" => @opp_off_reb,
		# 			"team_minutes" => @team_minutes,
		# 			"minutes" => @minutes,
		# 			"team_def_reb" => @team_def_reb,
		# 		},
		# 		value: defensive_rebound_pct
		# 	})
		# end

	end

	def three_pt_attempt_rate()
		three_point_attempt_rate = Stats::Advanced::ThreePtAttemptRateService.new({
			three_point_att: @three_point_att,
			field_goal_att: @field_goal_att 
		}).call

		@create_hash.push({
			stat_list_id: 21,
			member_id: @member_id, 
			season_id: @season_id,
			game_id: @game_id,
			constituent_stats: {
				"three_point_att" => @three_point_att,
				"field_goal_att" => @field_goal_att 
			},
			value: three_point_attempt_rate
		})

		# AdvancedStat.create({
		# 	stat_list_id: 21,
		# 	member_id: @member_id, 
		# 	season_id: @season_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"three_point_att" => @three_point_att,
		# 		"field_goal_att" => @field_goal_att 
		# 	},
		# 	value: three_point_attempt_rate
		# })

		# season_stat = SeasonAdvancedStat.where(stat_list_id: 21, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	new_three_par = Stats::Advanced::ThreePtAttemptRateService.new({
		# 		three_point_att: @three_point_att + season_stat.constituent_stats["three_point_att"],
		# 		field_goal_att: @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 	}).call

		# 	season_stat.value = new_three_par
		# 	season_stat.constituent_stats = {
		# 		"three_point_att" => @three_point_att + season_stat.constituent_stats["three_point_att"],
		# 		"field_goal_att" => @field_goal_att  + season_stat.constituent_stats["field_goal_att"],
		# 	}
		# 	season_stat.save
		# else
			
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 21,
		# 		member_id: @member_id, 
		# 		season_id: @season_id,
		# 		constituent_stats: {
		# 			"three_point_att" => @three_point_att,
		# 			"field_goal_att" => @field_goal_att 
		# 		},
		# 		value: three_point_attempt_rate
		# 	})
		# end
	end

	def linear_per()
		linear_per = Stats::Advanced::Player::LinearPerService.new({
			field_goals: @field_goals,
			steals: @steals,
			three_point_makes: @three_point_fg,
			free_throw_makes: @free_throw_makes,
			blocks: @blocks,
			off_reb: @off_reb,
			assists: @assists,
			def_reb: @def_reb,
			fouls: @fouls,
			free_throw_misses: @free_throw_misses,
			field_goal_misses: @field_goal_misses,
			turnovers: @turnovers,
			minutes: @minutes
		}).call

		@create_hash.push({
			stat_list_id: 20,
			member_id: @member_id, 
			season_id: @season_id,
			game_id: @game_id,
			constituent_stats: {
				"field_goals" => @field_goals,
				"steals" => @steals,
				"three_point_makes" => @three_point_fg,
				"free_throw_makes" => @free_throw_makes,
				"blocks" => @blocks,
				"off_reb" => @off_reb,
				"assists" => @assists,
				"def_reb" => @def_reb,
				"fouls" => @fouls,
				"free_throw_misses" => @free_throw_misses,
				"field_goal_misses" => @field_goal_misses,
				"turnovers" => @turnovers,
				"minutes" => @minutes
			},
			value: linear_per
		})


		# AdvancedStat.create({
		# 	stat_list_id: 20,
		# 	member_id: @member_id, 
		# 	season_id: @season_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"field_goals" => @field_goals,
		# 		"steals" => @steals,
		# 		"three_point_makes" => @three_point_fg,
		# 		"free_throw_makes" => @free_throw_makes,
		# 		"blocks" => @blocks,
		# 		"off_reb" => @off_reb,
		# 		"assists" => @assists,
		# 		"def_reb" => @def_reb,
		# 		"fouls" => @fouls,
		# 		"free_throw_misses" => @free_throw_misses,
		# 		"field_goal_misses" => @field_goal_misses,
		# 		"turnovers" => @turnovers,
		# 		"minutes" => @minutes
		# 	},
		# 	value: linear_per
		# })

		# season_stat = SeasonAdvancedStat.where(stat_list_id: 20, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	new_per = Stats::Advanced::Player::LinearPerService.new({
		# 		field_goals: @field_goals + season_stat.constituent_stats["field_goals"],
		# 		steals: @steals + season_stat.constituent_stats["steals"],
		# 		three_point_makes: @three_point_fg + season_stat.constituent_stats["three_point_makes"],
		# 		free_throw_makes: @free_throw_makes + season_stat.constituent_stats["free_throw_makes"],
		# 		blocks: @blocks + season_stat.constituent_stats["blocks"],
		# 		off_reb: @off_reb + season_stat.constituent_stats["off_reb"],
		# 		assists: @assists + season_stat.constituent_stats["assists"],
		# 		def_reb: @def_reb + season_stat.constituent_stats["def_reb"],
		# 		fouls: @fouls + season_stat.constituent_stats["fouls"],
		# 		free_throw_misses: @free_throw_misses + season_stat.constituent_stats["free_throw_misses"],
		# 		field_goal_misses: @field_goal_misses + season_stat.constituent_stats["field_goal_misses"],
		# 		turnovers: @turnovers + season_stat.constituent_stats["turnovers"],
		# 		minutes: @minutes + season_stat.constituent_stats["minutes"],
		# 	}).call

		# 	season_stat.value = new_per
		# 	season_stat.constituent_stats = {
		# 		"field_goals" => @field_goals + season_stat.constituent_stats["field_goals"],
		# 		"steals" => @steals + season_stat.constituent_stats["steals"],
		# 		"three_point_makes" => @three_point_fg + season_stat.constituent_stats["three_point_makes"],
		# 		"free_throw_makes" => @free_throw_makes + season_stat.constituent_stats["free_throw_makes"],
		# 		"blocks" => @blocks + season_stat.constituent_stats["blocks"],
		# 		"off_reb" => @off_reb + season_stat.constituent_stats["off_reb"],
		# 		"assists" => @assists + season_stat.constituent_stats["assists"],
		# 		"def_reb" => @def_reb + season_stat.constituent_stats["def_reb"],
		# 		"fouls" => @fouls + season_stat.constituent_stats["fouls"],
		# 		"free_throw_misses" => @free_throw_misses + season_stat.constituent_stats["free_throw_misses"],
		# 		"field_goal_misses" => @field_goal_misses + season_stat.constituent_stats["field_goal_misses"],
		# 		"turnovers" => @turnovers + season_stat.constituent_stats["turnovers"],
		# 		"minutes" => @minutes + season_stat.constituent_stats["minutes"],
		# 	}
		# 	season_stat.save
		# else
			
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 20,
		# 		member_id: @member_id, 
		# 		season_id: @season_id,
		# 		constituent_stats: {
		# 			"field_goals" => @field_goals,
		# 			"steals" => @steals,
		# 			"three_point_makes" => @three_point_fg,
		# 			"free_throw_makes" => @free_throw_makes,
		# 			"blocks" => @blocks,
		# 			"off_reb" => @off_reb,
		# 			"assists" => @assists,
		# 			"def_reb" => @def_reb,
		# 			"fouls" => @fouls,
		# 			"free_throw_misses" => @free_throw_misses,
		# 			"field_goal_misses" => @field_goal_misses,
		# 			"turnovers" => @turnovers,
		# 			"minutes" => @minutes
		# 		},
		# 		value: linear_per
		# 	})
		# end
	end


	def free_throw_att_rate()
		free_throw_attempt_rate = Stats::Advanced::FreeThrowAttemptRateService.new({
			free_throw_att: @free_throw_att,
			field_goal_att: @field_goal_att
		}).call

		@create_hash.push({
			stat_list_id: 22,
			member_id: @member_id, 
			season_id: @season_id,
			game_id: @game_id,
			constituent_stats: {
				"free_throw_att" => @free_throw_att,
				"field_goal_att" => @field_goal_att
			},
			value: free_throw_attempt_rate
		})

		# AdvancedStat.create({
		# 	stat_list_id: 22,
		# 	member_id: @member_id, 
		# 	season_id: @season_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"free_throw_att" => @free_throw_att,
		# 		"field_goal_att" => @field_goal_att
		# 	},
		# 	value: free_throw_attempt_rate
		# })

		# season_stat = SeasonAdvancedStat.where(stat_list_id: 22, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	new_ft_ar = Stats::Advanced::FreeThrowAttemptRateService.new({
		# 		free_throw_att: @free_throw_att + season_stat.constituent_stats["free_throw_att"],
		# 		field_goal_att: @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 	}).call

		# 	season_stat.value = new_ft_ar
		# 	season_stat.constituent_stats = {
		# 		"free_throw_att" => @free_throw_att + season_stat.constituent_stats["free_throw_att"],
		# 		"field_goal_att" => @field_goal_att  + season_stat.constituent_stats["field_goal_att"],
		# 	}
		# 	season_stat.save
		# else
			
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 22,
		# 		member_id: @member_id, 
		# 		season_id: @season_id,
		# 		constituent_stats: {
		# 			"free_throw_att" => @free_throw_att,
		# 			"field_goal_att" => @field_goal_att
		# 		},
		# 		value: free_throw_attempt_rate
		# 	})
		# end
	end

	def effective_fg_pct()
		effective_fg_pct = Stats::Advanced::EffectiveFgPctService.new({
			field_goals: @field_goals,
			field_goal_att: @field_goal_att,
			three_point_fg: @three_point_fg,
		}).call

		@create_hash.push({
			stat_list_id: 18,
			member_id: @member_id, 
			season_id: @season_id,
			game_id: @game_id,
			constituent_stats: {
				"field_goals" => @field_goals,
				"field_goal_att" => @field_goal_att,
				"three_point_fg" => @three_point_fg,
			},
			value: effective_fg_pct
		})

		# AdvancedStat.create({
		# 	stat_list_id: 18,
		# 	member_id: @member_id, 
		# 	season_id: @season_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"field_goals" => @field_goals,
		# 		"field_goal_att" => @field_goal_att,
		# 		"three_point_fg" => @three_point_fg,
		# 	},
		# 	value: effective_fg_pct
		# })

		# season_stat = SeasonAdvancedStat.where(stat_list_id: 18, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	new_eff_fg_pct = Stats::Advanced::EffectiveFgPctService.new({
		# 		field_goals: @field_goals + season_stat.constituent_stats["field_goals"],
		# 		field_goal_att: @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 		three_point_fg: @three_point_fg + season_stat.constituent_stats["three_point_fg"],
		# 	}).call

		# 	season_stat.value = new_eff_fg_pct
		# 	season_stat.constituent_stats = {
		# 		"field_goals" => @field_goals + season_stat.constituent_stats["field_goals"],
		# 		"field_goal_att" => @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 		"three_point_fg" => @three_point_fg + season_stat.constituent_stats["three_point_fg"],
		# 	}
		# 	season_stat.save
		# else
			
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 18,
		# 		member_id: @member_id, 
		# 		season_id: @season_id,
		# 		constituent_stats: {
		# 			"field_goals" => @field_goals,
		# 			"field_goal_att" => @field_goal_att,
		# 			"three_point_fg" => @three_point_fg,
		# 		},
		# 		value: effective_fg_pct
		# 	})
		# end
	end

	def true_shooting()
		true_shooting = Stats::Advanced::TrueShootingPctService.new({
			points: @points,
			field_goal_att: @field_goal_att,
			free_throw_att: @free_throw_att,
		}).call

		@create_hash.push({
			stat_list_id: 19,
			member_id: @member_id, 
			season_id: @season_id,
			game_id: @game_id,
			constituent_stats: {
				"points" => @points,
				"field_goal_att" => @field_goal_att,
				"free_throw_att" => @free_throw_att,
			},
			value: true_shooting
		})

		# AdvancedStat.create({
		# 	stat_list_id: 19,
		# 	member_id: @member_id, 
		# 	season_id: @season_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"points" => @points,
		# 		"field_goal_att" => @field_goal_att,
		# 		"free_throw_att" => @free_throw_att,
		# 	},
		# 	value: true_shooting
		# })

		# season_stat = SeasonAdvancedStat.where(stat_list_id: 19, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	new_ts_pct = Stats::Advanced::TrueShootingPctService.new({
		# 		points: @points + season_stat.constituent_stats["points"],
		# 		field_goal_att: @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 		free_throw_att: @free_throw_att + season_stat.constituent_stats["free_throw_att"],
		# 	}).call

		# 	season_stat.value = new_ts_pct
		# 	season_stat.constituent_stats = {
		# 		"points" => @points + season_stat.constituent_stats["points"],
		# 		"field_goal_att" => @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 		"free_throw_att" => @free_throw_att + season_stat.constituent_stats["free_throw_att"],
		# 	}
		# 	season_stat.save
		# else
			
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 19,
		# 		member_id: @member_id, 
		# 		season_id: @season_id,
		# 		constituent_stats: {
		# 			"points" => @points,
		# 			"field_goal_att" => @field_goal_att,
		# 			"free_throw_att" => @free_throw_att,
		# 		},
		# 		value: true_shooting
		# 	})
		# end
	end

	def defensive_rating()
		@defensive_rating = Stats::Advanced::Player::DefensiveRatingService.new({
			steals: @steals,
			team_steals: @team_steals,
			blocks: @blocks,
			team_blocks: @team_blocks,
			def_reb: @def_reb,
			team_def_reb: @team_def_reb,
			opp_off_reb: @opp_off_reb,
			opp_field_goals_made: @opp_field_goals,
			opp_field_goal_att: @opp_field_goal_att,
			minutes: @minutes,
			team_minutes: @team_minutes,
			opp_minutes: @opp_minutes,
			opp_turnovers: @opp_turnovers,
			fouls: @fouls,
			team_fouls: @team_fouls,
			opp_free_throw_att: @opp_free_throw_att,
			opp_free_throws_made: @opp_free_throw_makes,
			opp_points: @opp_points,
			opp_possessions: @opp_possessions
		}).call

		@create_hash.push({
			stat_list_id: 25,
			member_id: @member_id, 
			season_id: @season_id,
			game_id: @game_id,
			constituent_stats: {
				"steals" => @steals, 
				"team_steals" => @team_steals, 
				"blocks" => @blocks, 
				"team_blocks" => @team_blocks, 
				"def_reb" => @def_reb, 
				"team_def_reb" => @team_def_reb, 
				"opp_off_reb" => @opp_off_reb, 
				"opp_field_goals_made" => @opp_field_goals, 
				"opp_field_goal_att" => @opp_field_goal_att, 
				"minutes" => @minutes,
				"team_minutes" => @team_minutes,
				"opp_minutes" => @opp_minutes,
				"opp_turnovers" => @opp_turnovers,
				"fouls" => @fouls,
				"team_fouls" => @team_fouls,
				"opp_free_throw_att" => @opp_free_throw_att,
				"opp_free_throws_made" => @opp_free_throw_makes,
				"opp_points" => @opp_points,
				"opp_possessions" => @opp_possessions
			},
			value: @defensive_rating
		})

		# AdvancedStat.create({
		# 	stat_list_id: 25,
		# 	member_id: @member_id, 
		# 	season_id: @season_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"steals" => @steals, 
		# 		"team_steals" => @team_steals, 
		# 		"blocks" => @blocks, 
		# 		"team_blocks" => @team_blocks, 
		# 		"def_reb" => @def_reb, 
		# 		"team_def_reb" => @team_def_reb, 
		# 		"opp_off_reb" => @opp_off_reb, 
		# 		"opp_field_goals_made" => @opp_field_goals, 
		# 		"opp_field_goal_att" => @opp_field_goal_att, 
		# 		"minutes" => @minutes,
		# 		"team_minutes" => @team_minutes,
		# 		"opp_minutes" => @opp_minutes,
		# 		"opp_turnovers" => @opp_turnovers,
		# 		"fouls" => @fouls,
		# 		"team_fouls" => @team_fouls,
		# 		"opp_free_throw_att" => @opp_free_throw_att,
		# 		"opp_free_throws_made" => @opp_free_throw_makes,
		# 		"opp_points" => @opp_points,
		# 		"opp_possessions" => @opp_possessions
		# 	},
		# 	value: @defensive_rating
		# })
		puts "@opp_field_goals"
		puts @opp_field_goals
		# season_stat = SeasonAdvancedStat.where(stat_list_id: 25, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	@new_def_rtg = Stats::Advanced::Player::DefensiveRatingService.new({
		# 		steals: @steals + season_stat.constituent_stats["steals"],
		# 		team_steals: @team_steals + season_stat.constituent_stats["team_steals"],
		# 		blocks: @blocks + season_stat.constituent_stats["blocks"],
		# 		team_blocks: @team_blocks + season_stat.constituent_stats["team_blocks"],
		# 		def_reb: @def_reb + season_stat.constituent_stats["def_reb"],
		# 		team_def_reb: @team_def_reb + season_stat.constituent_stats["team_def_reb"],
		# 		opp_off_reb: @opp_off_reb + season_stat.constituent_stats["opp_off_reb"],
		# 		opp_field_goals_made: @opp_field_goals + season_stat.constituent_stats["opp_field_goals_made"],
		# 		opp_field_goal_att: @opp_field_goal_att + season_stat.constituent_stats["opp_field_goal_att"],
		# 		minutes: @minutes + season_stat.constituent_stats["minutes"],
		# 		team_minutes: @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		opp_minutes: @opp_minutes + season_stat.constituent_stats["opp_minutes"],
		# 		opp_turnovers: @opp_turnovers + season_stat.constituent_stats["opp_turnovers"],
		# 		fouls: @fouls + season_stat.constituent_stats["fouls"],
		# 		team_fouls: @team_fouls + season_stat.constituent_stats["team_fouls"],
		# 		opp_free_throw_att: @opp_free_throw_att + season_stat.constituent_stats["opp_free_throw_att"],
		# 		opp_free_throws_made: @opp_free_throw_makes + season_stat.constituent_stats["opp_free_throws_made"],
		# 		opp_points: @opp_points + season_stat.constituent_stats["opp_points"],
		# 		opp_possessions: @opp_possessions + season_stat.constituent_stats["opp_possessions"]
		# 	}).call

		# 	season_stat.value = @new_def_rtg
		# 	season_stat.constituent_stats = {
		# 		"steals" => @steals + season_stat.constituent_stats["steals"],
		# 		"team_steals" => @team_steals + season_stat.constituent_stats["team_steals"],
		# 		"blocks" => @blocks + season_stat.constituent_stats["blocks"],
		# 		"team_blocks" => @team_blocks + season_stat.constituent_stats["team_blocks"],
		# 		"def_reb" => @def_reb + season_stat.constituent_stats["def_reb"],
		# 		"team_def_reb" => @team_def_reb + season_stat.constituent_stats["team_def_reb"],
		# 		"opp_off_reb" => @opp_off_reb + season_stat.constituent_stats["opp_off_reb"],
		# 		"opp_field_goals_made" => @opp_field_goals + season_stat.constituent_stats["opp_field_goals_made"],
		# 		"opp_field_goal_att" => @opp_field_goal_att + season_stat.constituent_stats["opp_field_goal_att"],
		# 		"minutes" => @minutes + season_stat.constituent_stats["minutes"],
		# 		"team_minutes" => @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		"opp_minutes" => @opp_minutes + season_stat.constituent_stats["opp_minutes"],
		# 		"opp_turnovers" => @opp_turnovers + season_stat.constituent_stats["opp_turnovers"],
		# 		"fouls" => @fouls + season_stat.constituent_stats["fouls"],
		# 		"team_fouls" => @team_fouls + season_stat.constituent_stats["team_fouls"],
		# 		"opp_free_throw_att" => @opp_free_throw_att + season_stat.constituent_stats["opp_free_throw_att"],
		# 		"opp_free_throws_made" => @opp_free_throw_makes + season_stat.constituent_stats["opp_free_throws_made"],
		# 		"opp_points" => @opp_points + season_stat.constituent_stats["opp_points"],
		# 		"opp_possessions" => @opp_possessions + season_stat.constituent_stats["opp_possessions"]
		# 	}
		# 	season_stat.save
		# else	
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 25,
		# 		member_id: @member_id, 
		# 		season_id: @season_id,
		# 		constituent_stats: {
		# 			"steals" => @steals, 
		# 			"team_steals" => @team_steals, 
		# 			"blocks" => @blocks, 
		# 			"team_blocks" => @team_blocks, 
		# 			"def_reb" => @def_reb, 
		# 			"team_def_reb" => @team_def_reb, 
		# 			"opp_off_reb" => @opp_off_reb, 
		# 			"opp_field_goals_made" => @opp_field_goals, 
		# 			"opp_field_goal_att" => @opp_field_goal_att, 
		# 			"minutes" => @minutes,
		# 			"team_minutes" => @team_minutes,
		# 			"opp_minutes" => @opp_minutes,
		# 			"opp_turnovers" => @opp_turnovers,
		# 			"fouls" => @fouls,
		# 			"team_fouls" => @team_fouls,
		# 			"opp_free_throw_att" => @opp_free_throw_att,
		# 			"opp_free_throws_made" => @opp_free_throw_makes,
		# 			"opp_points" => @opp_points,
		# 			"opp_possessions" => @opp_possessions,
		# 		},
		# 		value: @defensive_rating
		# 	})
		# 	@new_def_rtg = @defensive_rating
		# end
	end

	def offensive_rating()
		@offensive_rating = Stats::Advanced::Player::OffensiveRatingService.new({
			team_off_reb: @team_off_reb,
			off_reb: @off_reb,
			opp_total_reb: @opp_def_reb + @opp_off_reb,
			opp_off_reb: @opp_off_reb,
			field_goals: @field_goals,
			team_field_goals: @team_field_goals,
			team_three_point_fg: @team_three_point_fg,
			three_point_fg: @three_point_fg,
			points: @points,
			team_points: @team_points,
			free_throw_att: @free_throw_att,
			free_throw_makes: @free_throw_makes,
			team_free_throw_att: @team_free_throw_att,
			team_free_throw_makes: @team_free_throw_makes,
			field_goal_att: @field_goal_att,
			team_field_goal_att: @team_field_goal_att,
			minutes: @minutes,
			team_minutes: @team_minutes,
			team_assists: @team_assists,
			assists: @assists,
			turnovers: @turnovers,
			team_turnovers: @team_turnovers,
		}).call

		@create_hash.push({
			stat_list_id: 24,
			member_id: @member_id, 
			season_id: @season_id,
			game_id: @game_id,
			constituent_stats: {
				"team_off_reb" => @team_off_reb,
				"off_reb" => @off_reb,
				"opp_total_reb" => @opp_total_reb,
				"opp_off_reb" => @opp_off_reb,
				"field_goals" => @field_goals,
				"team_field_goals" => @team_field_goals,
				"team_three_point_fg" => @team_three_point_fg,
				"three_point_fg" => @three_point_fg,
				"points" => @points,
				"team_points" => @team_points,
				"free_throw_att" => @free_throw_att,
				"free_throw_makes" => @free_throw_makes,
				"team_free_throw_att" => @team_free_throw_att,
				"team_free_throw_makes" => @team_free_throw_makes,
				"field_goal_att" => @field_goal_att,
				"team_field_goal_att" => @team_field_goal_att,
				"minutes" => @minutes,
				"team_minutes" => @team_minutes,
				"team_assists" => @team_assists,
				"assists" => @assists,
				"turnovers" => @turnovers,
				"team_turnovers" => @team_turnovers,
			},
			value: @offensive_rating
		})

		# AdvancedStat.create({
		# 	stat_list_id: 24,
		# 	member_id: @member_id, 
		# 	season_id: @season_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"team_off_reb" => @team_off_reb,
		# 		"off_reb" => @off_reb,
		# 		"opp_total_reb" => @opp_total_reb,
		# 		"opp_off_reb" => @opp_off_reb,
		# 		"field_goals" => @field_goals,
		# 		"team_field_goals" => @team_field_goals,
		# 		"team_three_point_fg" => @team_three_point_fg,
		# 		"three_point_fg" => @three_point_fg,
		# 		"points" => @points,
		# 		"team_points" => @team_points,
		# 		"free_throw_att" => @free_throw_att,
		# 		"free_throw_makes" => @free_throw_makes,
		# 		"team_free_throw_att" => @team_free_throw_att,
		# 		"team_free_throw_makes" => @team_free_throw_makes,
		# 		"field_goal_att" => @field_goal_att,
		# 		"team_field_goal_att" => @team_field_goal_att,
		# 		"minutes" => @minutes,
		# 		"team_minutes" => @team_minutes,
		# 		"team_assists" => @team_assists,
		# 		"assists" => @assists,
		# 		"turnovers" => @turnovers,
		# 		"team_turnovers" => @team_turnovers,
		# 	},
		# 	value: @offensive_rating
		# })

		# season_stat = SeasonAdvancedStat.where(stat_list_id: 24, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	@new_off_rtg = Stats::Advanced::Player::OffensiveRatingService.new({
		# 		team_off_reb: @team_off_reb + season_stat.constituent_stats["team_off_reb"],
		# 		off_reb: @off_reb + season_stat.constituent_stats["off_reb"],
		# 		opp_total_reb: @opp_total_reb + season_stat.constituent_stats["opp_total_reb"],
		# 		opp_off_reb: @opp_off_reb + season_stat.constituent_stats["opp_off_reb"],
		# 		field_goals: @field_goals + season_stat.constituent_stats["field_goals"],
		# 		team_field_goals: @team_field_goals + season_stat.constituent_stats["team_field_goals"],
		# 		team_three_point_fg: @team_three_point_fg + season_stat.constituent_stats["team_three_point_fg"],
		# 		three_point_fg: @three_point_fg + season_stat.constituent_stats["three_point_fg"],
		# 		points: @points + season_stat.constituent_stats["points"],
		# 		team_points: @team_points + season_stat.constituent_stats["team_points"],
		# 		free_throw_att: @free_throw_att + season_stat.constituent_stats["free_throw_att"],
		# 		free_throw_makes: @free_throw_makes + season_stat.constituent_stats["free_throw_makes"],
		# 		team_free_throw_att: @team_free_throw_att + season_stat.constituent_stats["team_free_throw_att"],
		# 		team_free_throw_makes: @team_free_throw_makes + season_stat.constituent_stats["team_free_throw_makes"],
		# 		field_goal_att: @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 		team_field_goal_att: @team_field_goal_att + season_stat.constituent_stats["team_field_goal_att"],
		# 		minutes: @minutes + season_stat.constituent_stats["minutes"],
		# 		team_minutes: @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		team_assists: @team_assists + season_stat.constituent_stats["team_assists"],
		# 		assists: @assists + season_stat.constituent_stats["assists"],
		# 		turnovers: @turnovers + season_stat.constituent_stats["turnovers"],
		# 		team_turnovers: @team_turnovers + season_stat.constituent_stats["team_turnovers"],
		# 	}).call

		# 	season_stat.value = @new_off_rtg
		# 	season_stat.constituent_stats = {
		# 		"team_off_reb" => @team_off_reb + season_stat.constituent_stats["team_off_reb"],
		# 		"off_reb" => @off_reb + season_stat.constituent_stats["off_reb"],
		# 		"opp_total_reb" => @opp_total_reb + season_stat.constituent_stats["opp_total_reb"],
		# 		"opp_off_reb" => @opp_off_reb + season_stat.constituent_stats["opp_off_reb"],
		# 		"field_goals" => @field_goals + season_stat.constituent_stats["field_goals"],
		# 		"team_field_goals" => @team_field_goals + season_stat.constituent_stats["team_field_goals"],
		# 		"team_three_point_fg" => @team_three_point_fg + season_stat.constituent_stats["team_three_point_fg"],
		# 		"three_point_fg" => @three_point_fg + season_stat.constituent_stats["three_point_fg"],
		# 		"points" => @points + season_stat.constituent_stats["points"],
		# 		"team_points" => @team_points + season_stat.constituent_stats["team_points"],
		# 		"free_throw_att" => @free_throw_att + season_stat.constituent_stats["free_throw_att"],
		# 		"free_throw_makes" => @free_throw_makes + season_stat.constituent_stats["free_throw_makes"],
		# 		"team_free_throw_att" => @team_free_throw_att + season_stat.constituent_stats["team_free_throw_att"],
		# 		"team_free_throw_makes" => @team_free_throw_makes + season_stat.constituent_stats["team_free_throw_makes"],
		# 		"field_goal_att" => @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 		"team_field_goal_att" => @team_field_goal_att + season_stat.constituent_stats["team_field_goal_att"],
		# 		"minutes" => @minutes + season_stat.constituent_stats["minutes"],
		# 		"team_minutes" => @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		"team_assists" => @team_assists + season_stat.constituent_stats["team_assists"],
		# 		"assists" => @assists + season_stat.constituent_stats["assists"],
		# 		"turnovers" => @turnovers + season_stat.constituent_stats["turnovers"],
		# 		"team_turnovers" => @team_turnovers + season_stat.constituent_stats["team_turnovers"],
		# 	}
		# 	season_stat.save
		# else	
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 24,
		# 		member_id: @member_id, 
		# 		season_id: @season_id,
		# 		constituent_stats: {
		# 			"team_off_reb" => @team_off_reb,
		# 			"off_reb" => @off_reb,
		# 			"opp_total_reb" => @opp_total_reb,
		# 			"opp_off_reb" => @opp_off_reb,
		# 			"field_goals" => @field_goals,
		# 			"team_field_goals" => @team_field_goals,
		# 			"team_three_point_fg" => @team_three_point_fg,
		# 			"three_point_fg" => @three_point_fg,
		# 			"points" => @points,
		# 			"team_points" => @team_points,
		# 			"free_throw_att" => @free_throw_att,
		# 			"free_throw_makes" => @free_throw_makes,
		# 			"team_free_throw_att" => @team_free_throw_att,
		# 			"team_free_throw_makes" => @team_free_throw_makes,
		# 			"field_goal_att" => @field_goal_att,
		# 			"team_field_goal_att" => @team_field_goal_att,
		# 			"minutes" => @minutes,
		# 			"team_minutes" => @team_minutes,
		# 			"team_assists" => @team_assists,
		# 			"assists" => @assists,
		# 			"turnovers" => @turnovers,
		# 			"team_turnovers" => @team_turnovers,
		# 		},
		# 		value: @offensive_rating
		# 	})
		# 	@new_off_rtg = @offensive_rating
		# end
	end

	def net_rating()
		net_rating =  @offensive_rating - @defensive_rating
		net_rating = net_rating * 100
		net_rating = net_rating.round / 100.0
			
		@create_hash.push({
			stat_list_id: 26,
			member_id: @member_id, 
			season_id: @season_id,
			game_id: @game_id,
			constituent_stats: {
				"offensive_rating" => @offensive_rating,
				"defensive_rating" => @defensive_rating,
			},
			value: net_rating
		})

		# AdvancedStat.create({
		# 	stat_list_id: 26,
		# 	member_id: @member_id, 
		# 	season_id: @season_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"offensive_rating" => @offensive_rating,
		# 		"defensive_rating" => @defensive_rating,
		# 	},
		# 	value: net_rating
		# })

		# season_stat = SeasonAdvancedStat.where(stat_list_id: 26, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	season_stat.value = @new_off_rtg - @new_def_rtg
		# 	season_stat.constituent_stats = {
		# 		"offensive_rating" => @new_off_rtg,
		# 		"defensive_rating" => @new_def_rtg,
		# 	}
		# 	season_stat.save
		# else
			
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 26,
		# 		member_id: @member_id, 
		# 		season_id: @season_id,
		# 		constituent_stats: {
		# 			"offensive_rating" => @offensive_rating,
		# 			"defensive_rating" => @defensive_rating,
		# 		},
		# 		value: net_rating
		# 	})
		# end
	end

	def box_plus_minus()
		@box_plus_minus = Stats::Advanced::Player::BoxPlusMinusService.new({
			off_reb: @off_reb,
			def_reb: @def_reb,
			opp_def_reb: @opp_def_reb,
			opp_off_reb: @opp_off_reb,
			team_off_reb: @team_off_reb,
			team_def_reb: @team_def_reb,
			steals: @steals,
			minutes: @minutes,
			team_minutes: @team_minutes,
			opp_field_goal_att: @opp_field_goal_att,
			opp_field_goals: @opp_field_goals,
			opp_free_throw_att: @opp_free_throw_att,
			opp_three_point_att: @opp_three_point_att,
			blocks: @blocks,
			team_field_goals: @team_field_goals,
			field_goals: @field_goals,
			assists: @assists,
			turnovers: @turnovers,
			opp_turnovers: @opp_turnovers,
			free_throw_att: @free_throw_att,
			field_goal_att: @field_goal_att,
			team_turnovers: @team_turnovers,
			points: @points,
			team_points: @team_points,
			team_field_goal_att: @team_field_goal_att,
			team_free_throw_att: @team_free_throw_att,
			three_point_att: @three_point_att,
			team_three_point_att: @team_three_point_att,
			bpm_type: "regular",
			possessions: @possessions,
			opp_possessions: @opp_possessions
		}).call

		@create_hash.push({
			stat_list_id: 44,
			member_id: @member_id, 
			season_id: @season_id,
			game_id: @game_id,
			constituent_stats: {
				"off_reb" => @off_reb,
				"def_reb" => @def_reb,
				"opp_def_reb" => @opp_def_reb,
				"opp_off_reb" => @opp_off_reb,
				"team_off_reb" => @team_off_reb,
				"team_def_reb" => @team_def_reb,
				"steals" => @steals,
				"minutes" => @minutes,
				"team_minutes" => @team_minutes,
				"opp_field_goal_att" => @opp_field_goal_att,
				"opp_field_goals" => @opp_field_goals,
				"opp_free_throw_att" => @opp_free_throw_att,
				"opp_three_point_att" => @opp_three_point_att,
				"blocks" => @blocks,
				"team_field_goals" => @team_field_goals,
				"field_goals" => @field_goals,
				"assists" => @assists,
				"turnovers" => @turnovers,
				"opp_turnovers" => @opp_turnovers,
				"free_throw_att" => @free_throw_att,
				"field_goal_att" => @field_goal_att,
				"team_turnovers" => @team_turnovers,
				"points" => @points,
				"team_points" => @team_points,
				"team_field_goal_att" => @team_field_goal_att,
				"team_free_throw_att" => @team_free_throw_att,
				"three_point_att" => @three_point_att,
				"team_three_point_att" => @team_three_point_att,
				"possessions" => @possessions,
				"opp_possessions" => @opp_possessions
			},
			value: @box_plus_minus
		})

		# @bpm = AdvancedStat.create({
		# 	stat_list_id: 44,
		# 	member_id: @member_id, 
		# 	season_id: @season_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"off_reb" => @off_reb,
		# 		"def_reb" => @def_reb,
		# 		"opp_def_reb" => @opp_def_reb,
		# 		"opp_off_reb" => @opp_off_reb,
		# 		"team_off_reb" => @team_off_reb,
		# 		"team_def_reb" => @team_def_reb,
		# 		"steals" => @steals,
		# 		"minutes" => @minutes,
		# 		"team_minutes" => @team_minutes,
		# 		"opp_field_goal_att" => @opp_field_goal_att,
		# 		"opp_field_goals" => @opp_field_goals,
		# 		"opp_free_throw_att" => @opp_free_throw_att,
		# 		"opp_three_point_att" => @opp_three_point_att,
		# 		"blocks" => @blocks,
		# 		"team_field_goals" => @team_field_goals,
		# 		"field_goals" => @field_goals,
		# 		"assists" => @assists,
		# 		"turnovers" => @turnovers,
		# 		"opp_turnovers" => @opp_turnovers,
		# 		"free_throw_att" => @free_throw_att,
		# 		"field_goal_att" => @field_goal_att,
		# 		"team_turnovers" => @team_turnovers,
		# 		"points" => @points,
		# 		"team_points" => @team_points,
		# 		"team_field_goal_att" => @team_field_goal_att,
		# 		"team_free_throw_att" => @team_free_throw_att,
		# 		"three_point_att" => @three_point_att,
		# 		"team_three_point_att" => @team_three_point_att,
		# 		"possessions" => @possessions,
		# 		"opp_possessions" => @opp_possessions
		# 	},
		# 	value: @box_plus_minus
		# })

		# season_stat = SeasonAdvancedStat.where(stat_list_id: 44, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	@new_bpm = Stats::Advanced::Player::BoxPlusMinusService.new({
		# 		off_reb: @off_reb + season_stat.constituent_stats["off_reb"],
		# 		def_reb: @def_reb+ season_stat.constituent_stats["def_reb"],
		# 		opp_def_reb: @opp_def_reb + season_stat.constituent_stats["opp_def_reb"],
		# 		opp_off_reb: @opp_off_reb + season_stat.constituent_stats["opp_off_reb"],
		# 		team_off_reb: @team_off_reb + season_stat.constituent_stats["team_off_reb"],
		# 		team_def_reb: @team_def_reb + season_stat.constituent_stats["team_def_reb"],
		# 		steals: @steals + season_stat.constituent_stats["steals"],
		# 		minutes: @minutes + season_stat.constituent_stats["minutes"],
		# 		team_minutes: @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		opp_field_goal_att: @opp_field_goal_att + season_stat.constituent_stats["opp_field_goal_att"],
		# 		opp_field_goals: @opp_field_goals + season_stat.constituent_stats["opp_field_goals"],
		# 		opp_free_throw_att: @opp_free_throw_att + season_stat.constituent_stats["opp_free_throw_att"],
		# 		opp_three_point_att: @opp_three_point_att + season_stat.constituent_stats["opp_three_point_att"],
		# 		blocks: @blocks + season_stat.constituent_stats["blocks"],
		# 		team_field_goals: @team_field_goals + season_stat.constituent_stats["team_field_goals"],
		# 		field_goals: @field_goals + season_stat.constituent_stats["field_goals"],
		# 		assists: @assists + season_stat.constituent_stats["assists"],
		# 		turnovers: @turnovers + season_stat.constituent_stats["turnovers"],
		# 		opp_turnovers: @opp_turnovers + season_stat.constituent_stats["opp_turnovers"],
		# 		free_throw_att: @free_throw_att + season_stat.constituent_stats["free_throw_att"],
		# 		field_goal_att: @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 		team_turnovers: @team_turnovers + season_stat.constituent_stats["team_turnovers"],
		# 		points: @points + season_stat.constituent_stats["points"],
		# 		team_points: @team_points + season_stat.constituent_stats["team_points"],
		# 		team_field_goal_att: @team_field_goal_att + season_stat.constituent_stats["team_field_goal_att"],
		# 		team_free_throw_att: @team_free_throw_att + season_stat.constituent_stats["team_free_throw_att"],
		# 		three_point_att: @three_point_att + season_stat.constituent_stats["three_point_att"],
		# 		team_three_point_att: @team_three_point_att + season_stat.constituent_stats["team_three_point_att"],
		# 		possessions: @possessions + season_stat.constituent_stats["possessions"],
		# 		opp_possessions: @opp_possessions + season_stat.constituent_stats["opp_possessions"],
		# 		bpm_type: "regular",
		# 	}).call

		# 	season_stat.value = @new_bpm
		# 	season_stat.constituent_stats = {
		# 		"off_reb" => @off_reb + season_stat.constituent_stats["off_reb"],
		# 		"def_reb" => @def_reb + season_stat.constituent_stats["def_reb"],
		# 		"opp_def_reb" => @opp_def_reb + season_stat.constituent_stats["opp_def_reb"],
		# 		"opp_off_reb" => @opp_off_reb + season_stat.constituent_stats["opp_off_reb"],
		# 		"team_off_reb" => @team_off_reb + season_stat.constituent_stats["team_off_reb"],
		# 		"team_def_reb" => @team_def_reb + season_stat.constituent_stats["team_def_reb"],
		# 		"steals" => @steals + season_stat.constituent_stats["steals"],
		# 		"minutes" => @minutes + season_stat.constituent_stats["minutes"],
		# 		"team_minutes" => @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		"opp_field_goal_att" => @opp_field_goal_att + season_stat.constituent_stats["opp_field_goal_att"],
		# 		"opp_field_goals" => @opp_field_goals + season_stat.constituent_stats["opp_field_goals"],
		# 		"opp_free_throw_att" => @opp_free_throw_att + season_stat.constituent_stats["opp_free_throw_att"],
		# 		"opp_three_point_att" => @opp_three_point_att + season_stat.constituent_stats["opp_three_point_att"],
		# 		"blocks" => @blocks + season_stat.constituent_stats["blocks"],
		# 		"team_field_goals" => @team_field_goals + season_stat.constituent_stats["team_field_goals"],
		# 		"field_goals" => @field_goals + season_stat.constituent_stats["field_goals"],
		# 		"assists" => @assists + season_stat.constituent_stats["assists"],
		# 		"turnovers" => @turnovers + season_stat.constituent_stats["turnovers"],
		# 		"opp_turnovers" => @opp_turnovers + season_stat.constituent_stats["opp_turnovers"],
		# 		"free_throw_att" => @free_throw_att + season_stat.constituent_stats["free_throw_att"],
		# 		"field_goal_att" => @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 		"team_turnovers" => @team_turnovers + season_stat.constituent_stats["team_turnovers"],
		# 		"points" => @points + season_stat.constituent_stats["points"],
		# 		"team_points" => @team_points + season_stat.constituent_stats["team_points"],
		# 		"team_field_goal_att" => @team_field_goal_att + season_stat.constituent_stats["team_field_goal_att"],
		# 		"team_free_throw_att" => @team_free_throw_att + season_stat.constituent_stats["team_free_throw_att"],
		# 		"three_point_att" => @three_point_att + season_stat.constituent_stats["three_point_att"],
		# 		"team_three_point_att" => @team_three_point_att + season_stat.constituent_stats["team_three_point_att"],
		# 		"possessions" => @possessions + season_stat.constituent_stats["possessions"],
		# 		"opp_possessions" => @opp_possessions + season_stat.constituent_stats["opp_possessions"],
		# 	}
		# 	season_stat.save
		# 	@season_bpm = season_stat
		# else	
		# 	@season_bpm = SeasonAdvancedStat.create({
		# 		stat_list_id: 44,
		# 		member_id: @member_id, 
		# 		season_id: @season_id,
		# 		constituent_stats: {
		# 			"off_reb" => @off_reb,
		# 			"def_reb" => @def_reb,
		# 			"opp_def_reb" => @opp_def_reb,
		# 			"opp_off_reb" => @opp_off_reb,
		# 			"team_off_reb" => @team_off_reb,
		# 			"team_def_reb" => @team_def_reb,
		# 			"steals" => @steals,
		# 			"minutes" => @minutes,
		# 			"team_minutes" => @team_minutes,
		# 			"opp_field_goal_att" => @opp_field_goal_att,
		# 			"opp_field_goals" => @opp_field_goals,
		# 			"opp_free_throw_att" => @opp_free_throw_att,
		# 			"opp_three_point_att" => @opp_three_point_att,
		# 			"blocks" => @blocks,
		# 			"team_field_goals" => @team_field_goals,
		# 			"field_goals" => @field_goals,
		# 			"assists" => @assists,
		# 			"turnovers" => @turnovers,
		# 			"opp_turnovers" => @opp_turnovers,
		# 			"free_throw_att" => @free_throw_att,
		# 			"field_goal_att" => @field_goal_att,
		# 			"team_turnovers" => @team_turnovers,
		# 			"points" => @points,
		# 			"team_points" => @team_points,
		# 			"team_field_goal_att" => @team_field_goal_att,
		# 			"team_free_throw_att" => @team_free_throw_att,
		# 			"three_point_att" => @three_point_att,
		# 			"team_three_point_att" => @team_three_point_att,
		# 			"possessions" => @possessions,
		# 			"opp_possessions" => @opp_possessions
		# 		},
		# 		value: @box_plus_minus
		# 	})
		# 	@new_bpm = @box_plus_minus
		# end

	end

	def off_box_plus_minus()
		@off_box_plus_minus = Stats::Advanced::Player::BoxPlusMinusService.new({
			off_reb: @off_reb,
			def_reb: @def_reb,
			opp_def_reb: @opp_def_reb,
			opp_off_reb: @opp_off_reb,
			team_off_reb: @team_off_reb,
			team_def_reb: @team_def_reb,
			steals: @steals,
			minutes: @minutes,
			team_minutes: @team_minutes,
			opp_field_goal_att: @opp_field_goal_att,
			opp_field_goals: @opp_field_goals,
			opp_free_throw_att: @opp_free_throw_att,
			opp_three_point_att: @opp_three_point_att,
			blocks: @blocks,
			team_field_goals: @team_field_goals,
			field_goals: @field_goals,
			assists: @assists,
			turnovers: @turnovers,
			opp_turnovers: @opp_turnovers,
			free_throw_att: @free_throw_att,
			field_goal_att: @field_goal_att,
			team_turnovers: @team_turnovers,
			points: @points,
			team_points: @team_points,
			team_field_goal_att: @team_field_goal_att,
			team_free_throw_att: @team_free_throw_att,
			three_point_att: @three_point_att,
			team_three_point_att: @team_three_point_att,
			bpm_type: "offensive",
			possessions: @possessions,
			opp_possessions: @opp_possessions,
		}).call

		@create_hash.push({
			stat_list_id: 45,
			member_id: @member_id, 
			season_id: @season_id,
			game_id: @game_id,
			constituent_stats: {
				"off_reb" => @off_reb,
				"def_reb" => @def_reb,
				"opp_def_reb" => @opp_def_reb,
				"opp_off_reb" => @opp_off_reb,
				"team_off_reb" => @team_off_reb,
				"team_def_reb" => @team_def_reb,
				"steals" => @steals,
				"minutes" => @minutes,
				"team_minutes" => @team_minutes,
				"opp_field_goal_att" => @opp_field_goal_att,
				"opp_field_goals" => @opp_field_goals,
				"opp_free_throw_att" => @opp_free_throw_att,
				"opp_three_point_att" => @opp_three_point_att,
				"blocks" => @blocks,
				"team_field_goals" => @team_field_goals,
				"field_goals" => @field_goals,
				"assists" => @assists,
				"turnovers" => @turnovers,
				"opp_turnovers" => @opp_turnovers,
				"free_throw_att" => @free_throw_att,
				"field_goal_att" => @field_goal_att,
				"team_turnovers" => @team_turnovers,
				"points" => @points,
				"team_points" => @team_points,
				"team_field_goal_att" => @team_field_goal_att,
				"team_free_throw_att" => @team_free_throw_att,
				"three_point_att" => @three_point_att,
				"team_three_point_att" => @team_three_point_att,
				"possessions" => @possessions,
				"opp_possessions" => @opp_possessions
			},
			value: @off_box_plus_minus
		})

		# @obpm = AdvancedStat.create({
		# 	stat_list_id: 45,
		# 	member_id: @member_id, 
		# 	season_id: @season_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"off_reb" => @off_reb,
		# 		"def_reb" => @def_reb,
		# 		"opp_def_reb" => @opp_def_reb,
		# 		"opp_off_reb" => @opp_off_reb,
		# 		"team_off_reb" => @team_off_reb,
		# 		"team_def_reb" => @team_def_reb,
		# 		"steals" => @steals,
		# 		"minutes" => @minutes,
		# 		"team_minutes" => @team_minutes,
		# 		"opp_field_goal_att" => @opp_field_goal_att,
		# 		"opp_field_goals" => @opp_field_goals,
		# 		"opp_free_throw_att" => @opp_free_throw_att,
		# 		"opp_three_point_att" => @opp_three_point_att,
		# 		"blocks" => @blocks,
		# 		"team_field_goals" => @team_field_goals,
		# 		"field_goals" => @field_goals,
		# 		"assists" => @assists,
		# 		"turnovers" => @turnovers,
		# 		"opp_turnovers" => @opp_turnovers,
		# 		"free_throw_att" => @free_throw_att,
		# 		"field_goal_att" => @field_goal_att,
		# 		"team_turnovers" => @team_turnovers,
		# 		"points" => @points,
		# 		"team_points" => @team_points,
		# 		"team_field_goal_att" => @team_field_goal_att,
		# 		"team_free_throw_att" => @team_free_throw_att,
		# 		"three_point_att" => @three_point_att,
		# 		"team_three_point_att" => @team_three_point_att,
		# 		"possessions" => @possessions,
		# 		"opp_possessions" => @opp_possessions
		# 	},
		# 	value: @off_box_plus_minus
		# })

		# season_stat = SeasonAdvancedStat.where(stat_list_id: 45, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	@new_obpm = Stats::Advanced::Player::BoxPlusMinusService.new({
		# 		off_reb: @off_reb + season_stat.constituent_stats["off_reb"],
		# 		def_reb: @def_reb+ season_stat.constituent_stats["def_reb"],
		# 		opp_def_reb: @opp_def_reb + season_stat.constituent_stats["opp_def_reb"],
		# 		opp_off_reb: @opp_off_reb + season_stat.constituent_stats["opp_off_reb"],
		# 		team_off_reb: @team_off_reb + season_stat.constituent_stats["team_off_reb"],
		# 		team_def_reb: @team_def_reb + season_stat.constituent_stats["team_def_reb"],
		# 		steals: @steals + season_stat.constituent_stats["steals"],
		# 		minutes: @minutes + season_stat.constituent_stats["minutes"],
		# 		team_minutes: @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		opp_field_goal_att: @opp_field_goal_att + season_stat.constituent_stats["opp_field_goal_att"],
		# 		opp_field_goals: @opp_field_goals + season_stat.constituent_stats["opp_field_goals"],
		# 		opp_free_throw_att: @opp_free_throw_att + season_stat.constituent_stats["opp_free_throw_att"],
		# 		opp_three_point_att: @opp_three_point_att + season_stat.constituent_stats["opp_three_point_att"],
		# 		blocks: @blocks + season_stat.constituent_stats["blocks"],
		# 		team_field_goals: @team_field_goals + season_stat.constituent_stats["team_field_goals"],
		# 		field_goals: @field_goals + season_stat.constituent_stats["field_goals"],
		# 		assists: @assists + season_stat.constituent_stats["assists"],
		# 		turnovers: @turnovers + season_stat.constituent_stats["turnovers"],
		# 		opp_turnovers: @opp_turnovers + season_stat.constituent_stats["opp_turnovers"],
		# 		free_throw_att: @free_throw_att + season_stat.constituent_stats["free_throw_att"],
		# 		field_goal_att: @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 		team_turnovers: @team_turnovers + season_stat.constituent_stats["team_turnovers"],
		# 		points: @points + season_stat.constituent_stats["points"],
		# 		team_points: @team_points + season_stat.constituent_stats["team_points"],
		# 		team_field_goal_att: @team_field_goal_att + season_stat.constituent_stats["team_field_goal_att"],
		# 		team_free_throw_att: @team_free_throw_att + season_stat.constituent_stats["team_free_throw_att"],
		# 		three_point_att: @three_point_att + season_stat.constituent_stats["three_point_att"],
		# 		team_three_point_att: @team_three_point_att + season_stat.constituent_stats["team_three_point_att"],
		# 		possessions: @possessions + season_stat.constituent_stats["possessions"],
		# 		opp_possessions: @opp_possessions + season_stat.constituent_stats["opp_possessions"],
		# 		bpm_type: "offensive",
		# 	}).call

		# 	season_stat.value = @new_obpm
		# 	season_stat.constituent_stats = {
		# 		"off_reb" => @off_reb + season_stat.constituent_stats["off_reb"],
		# 		"def_reb" => @def_reb + season_stat.constituent_stats["def_reb"],
		# 		"opp_def_reb" => @opp_def_reb + season_stat.constituent_stats["opp_def_reb"],
		# 		"opp_off_reb" => @opp_off_reb + season_stat.constituent_stats["opp_off_reb"],
		# 		"team_off_reb" => @team_off_reb + season_stat.constituent_stats["team_off_reb"],
		# 		"team_def_reb" => @team_def_reb + season_stat.constituent_stats["team_def_reb"],
		# 		"steals" => @steals + season_stat.constituent_stats["steals"],
		# 		"minutes" => @minutes + season_stat.constituent_stats["minutes"],
		# 		"team_minutes" => @team_minutes + season_stat.constituent_stats["team_minutes"],
		# 		"opp_field_goal_att" => @opp_field_goal_att + season_stat.constituent_stats["opp_field_goal_att"],
		# 		"opp_field_goals" => @opp_field_goals + season_stat.constituent_stats["opp_field_goals"],
		# 		"opp_free_throw_att" => @opp_free_throw_att + season_stat.constituent_stats["opp_free_throw_att"],
		# 		"opp_three_point_att" => @opp_three_point_att + season_stat.constituent_stats["opp_three_point_att"],
		# 		"blocks" => @blocks + season_stat.constituent_stats["blocks"],
		# 		"team_field_goals" => @team_field_goals + season_stat.constituent_stats["team_field_goals"],
		# 		"field_goals" => @field_goals + season_stat.constituent_stats["field_goals"],
		# 		"assists" => @assists + season_stat.constituent_stats["assists"],
		# 		"turnovers" => @turnovers + season_stat.constituent_stats["turnovers"],
		# 		"opp_turnovers" => @opp_turnovers + season_stat.constituent_stats["opp_turnovers"],
		# 		"free_throw_att" => @free_throw_att + season_stat.constituent_stats["free_throw_att"],
		# 		"field_goal_att" => @field_goal_att + season_stat.constituent_stats["field_goal_att"],
		# 		"team_turnovers" => @team_turnovers + season_stat.constituent_stats["team_turnovers"],
		# 		"points" => @points + season_stat.constituent_stats["points"],
		# 		"team_points" => @team_points + season_stat.constituent_stats["team_points"],
		# 		"team_field_goal_att" => @team_field_goal_att + season_stat.constituent_stats["team_field_goal_att"],
		# 		"team_free_throw_att" => @team_free_throw_att + season_stat.constituent_stats["team_free_throw_att"],
		# 		"three_point_att" => @three_point_att + season_stat.constituent_stats["three_point_att"],
		# 		"team_three_point_att" => @team_three_point_att + season_stat.constituent_stats["team_three_point_att"],
		# 		"possessions" => @possessions + season_stat.constituent_stats["possessions"],
		# 		"opp_possessions" => @opp_possessions + season_stat.constituent_stats["opp_possessions"],
		# 	}
		# 	season_stat.save
		# 	@season_obpm = season_stat
		# else	
		# 	@season_obpm = SeasonAdvancedStat.create({
		# 		stat_list_id: 45,
		# 		member_id: @member_id, 
		# 		season_id: @season_id,
		# 		constituent_stats: {
		# 			"off_reb" => @off_reb,
		# 			"def_reb" => @def_reb,
		# 			"opp_def_reb" => @opp_def_reb,
		# 			"opp_off_reb" => @opp_off_reb,
		# 			"team_off_reb" => @team_off_reb,
		# 			"team_def_reb" => @team_def_reb,
		# 			"steals" => @steals,
		# 			"minutes" => @minutes,
		# 			"team_minutes" => @team_minutes,
		# 			"opp_field_goal_att" => @opp_field_goal_att,
		# 			"opp_field_goals" => @opp_field_goals,
		# 			"opp_free_throw_att" => @opp_free_throw_att,
		# 			"opp_three_point_att" => @opp_three_point_att,
		# 			"blocks" => @blocks,
		# 			"team_field_goals" => @team_field_goals,
		# 			"field_goals" => @field_goals,
		# 			"assists" => @assists,
		# 			"turnovers" => @turnovers,
		# 			"opp_turnovers" => @opp_turnovers,
		# 			"free_throw_att" => @free_throw_att,
		# 			"field_goal_att" => @field_goal_att,
		# 			"team_turnovers" => @team_turnovers,
		# 			"points" => @points,
		# 			"team_points" => @team_points,
		# 			"team_field_goal_att" => @team_field_goal_att,
		# 			"team_free_throw_att" => @team_free_throw_att,
		# 			"three_point_att" => @three_point_att,
		# 			"team_three_point_att" => @team_three_point_att,
		# 			"possessions" => @possessions,
		# 			"opp_possessions" => @opp_possessions
		# 		},
		# 		value: @off_box_plus_minus
		# 	})
		# 	@new_obpm = @off_box_plus_minus
		# end
	end

	def def_box_plus_minus()
		def_box_plus_minus = @box_plus_minus - @off_box_plus_minus
		def_box_plus_minus = def_box_plus_minus * 100
		def_box_plus_minus = def_box_plus_minus.round / 100.0

		@create_hash.push({
			stat_list_id: 41,
			member_id: @member_id, 
			season_id: @season_id,
			game_id: @game_id,
			constituent_stats: {
				"obpm" => @off_box_plus_minus,
				"bpm" => @box_plus_minus,
			},
			value: def_box_plus_minus
		})

		# @dbpm = AdvancedStat.create({
		# 	stat_list_id: 41,
		# 	member_id: @member_id, 
		# 	season_id: @season_id,
		# 	game_id: @game_id,
		# 	constituent_stats: {
		# 		"obpm" => @off_box_plus_minus,
		# 		"bpm" => @box_plus_minus,
		# 	},
		# 	value: def_box_plus_minus
		# })

		# season_stat = SeasonAdvancedStat.where(stat_list_id: 41, member_id: @member_id, season_id: @season_id).select(:value, :constituent_stats).take
		# if season_stat
		# 	@new_dbpm = @new_bpm - @new_obpm
		# 	season_stat.value = @new_dbpm
		# 	season_stat.constituent_stats = {
		# 		"obpm" => @new_bpm,
		# 		"bpm" => @new_obpm,
		# 	}
		# 	season_stat.save
		# else
			
		# 	SeasonAdvancedStat.create({
		# 		stat_list_id: 41,
		# 		member_id: @member_id, season_id: @season_id,
		# 		constituent_stats: {
		# 			"obpm" => @off_box_plus_minus,
		# 			"bpm" => @box_plus_minus,
		# 		},
		# 		value: def_box_plus_minus
		# 	})
		# end


	end

	def create_stats
		AdvancedStat.create(@create_hash)
	end


end
