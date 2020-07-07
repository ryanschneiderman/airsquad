=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end


class Stats::Advanced::Player::BoxPlusMinusService
	def initialize(params)

		#PARAMETERS
		
		@off_reb = params[:off_reb]
		
		@def_reb = params[:def_reb]
		
		@total_reb = @off_reb + @def_reb
		
		@opp_def_reb = params[:opp_def_reb]
		
		@opp_off_reb = params[:opp_off_reb]
		
		@opp_total_reb = @opp_def_reb + @opp_off_reb
		
		@team_off_reb = params[:team_off_reb]
		
		@team_def_reb = params[:team_def_reb]
		
		@team_total_reb = @team_off_reb + @team_def_reb
		
		@steals = params[:steals]
		
		@minutes = params[:minutes]
		
		@team_minutes = params[:team_minutes]
		
		@opp_field_goal_att = params[:opp_field_goal_att]
		
		@opp_field_goals = params[:opp_field_goals]
		
		@opp_free_throw_att = params[:opp_free_throw_att]
		
		@opp_three_point_att = params[:opp_three_point_att]
		
		@blocks = params[:blocks]
		
		@team_field_goals = params[:team_field_goals]
		
		@field_goals = params[:field_goals]
		
		@assists = params[:assists]
		
		@turnovers = params[:turnovers]
		
		@opp_turnovers = params[:opp_turnovers]
		
		@free_throw_att = params[:free_throw_att]
		
		@field_goal_att = params[:field_goal_att]
		
		@team_turnovers = params[:team_turnovers]
		
		@points = params[:points]
		
		@team_points = params[:team_points]
		
		@team_field_goal_att = params[:team_field_goal_att]
		
		@team_free_throw_att = params[:team_free_throw_att]
		
		@three_point_att = params[:three_point_att]
		
		@team_three_point_att = params[:team_three_point_att]

		@possessions = params[:possessions]
		@opp_possessions = params[:opp_possessions]
		
		@bpm_type = params[:bpm_type]




		if @bpm_type == "regular"
			@a = 0.123391
			@b = 0.119597
			@c = -0.151287
			@d = 1.255644
			@e = 0.531838
			@f = -0.305868
			@g = 0.921292
			@h = 0.711217
			@i = 0.017022
			@j = 0.297639
			@k = 0.213485
			@l = 0.725930
		else
			@a = 0.064448
			@b = 0.211125
			@c = -0.107545
			@d = 0.346513
			@e = -0.052476
			@f = -0.041787
			@g = 0.932965
			@h = 0.687359
			@i = 0.007952
			@j = 0.374706
			@k = -0.181891
			@l = 0.239862
		end
	end

	def call

		off_reb_pct = Stats::Advanced::Player::OffensiveReboundPctService.new({
			off_reb: @off_reb,
			opp_def_reb: @opp_def_reb,
			team_minutes: @team_minutes,
			minutes: @minutes,
			team_off_reb: @team_off_reb
		}).call 
		def_reb_pct = Stats::Advanced::Player::DefensiveReboundPctService.new({
			def_reb: @def_reb,
			opp_off_reb: @opp_off_reb,
			team_minutes: @team_minutes,
			minutes: @minutes,
			team_def_reb: @team_def_reb,
		}).call 
		steal_pct = Stats::Advanced::Player::StealPctService.new({
			steals: @steals,
			team_minutes: @team_minutes,
			minutes: @minutes,
			opp_poss: @opp_possessions
		}).call 
		block_pct = Stats::Advanced::Player::BlockPctService.new({
			blocks: @blocks,
			team_minutes: @team_minutes,
			minutes: @minutes,
			opp_field_goal_att: @opp_field_goal_att,
			opp_three_point_att: @opp_three_point_att
		}).call 
		ast_pct = Stats::Advanced::Player::AssistPctService.new({
			assists: @assists,
			minutes: @minutes,
			team_minutes: @team_minutes,
			team_field_goals: @team_field_goals,
			field_goals: @field_goals,
		}).call 
		turnover_pct = Stats::Advanced::Player::TurnoverPctService.new({
			turnovers: @turnovers,
			field_goal_att: @field_goal_att,
			free_throw_att: @free_throw_att,
		}).call / 100
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
		true_shooting = Stats::Advanced::TrueShootingPctService.new({
			points: @points,
			field_goal_att: @field_goal_att,
			free_throw_att: @free_throw_att,

		}).call / 100
		team_true_shooting = Stats::Advanced::TrueShootingPctService.new({
			points: @team_points,
			field_goal_att: @team_field_goal_att,
			free_throw_att: @team_free_throw_att,
		}).call / 100
		three_point_att_rate = Stats::Advanced::ThreePtAttemptRateService.new({
			three_point_att: @three_point_att,
			field_goal_att: @field_goal_att
		}).call / 100
		team_three_point_att_rate = Stats::Advanced::ThreePtAttemptRateService.new({
			three_point_att: @team_three_point_att,
			field_goal_att: @team_field_goal_att,
		}).call / 100
		total_rebound_pct = Stats::Advanced::TotalReboundPctService.new({
			total_reb: @total_reb,
			team_minutes: @team_minutes,
			minutes: @minutes,
			team_total_reb: @team_total_reb,
			opp_total_reb: @opp_total_reb
		}).call
=begin
		puts "minutes"
		puts @minutes
		puts "team_minutes"
		puts @team_minutes 
		puts "ast pct"
		puts ast_pct
		puts "total reb %"
		puts total_rebound_pct
		puts "off_reb_pct"
		puts off_reb_pct
		puts "def_reb_pct"
		puts def_reb_pct
		puts "steal_pct"
		puts steal_pct
		puts "block_pct"
		puts block_pct
		puts "turnover_pct"
		puts turnover_pct
		puts "usage_rate"
		puts usage_rate
		puts "true_shooting"
		puts true_shooting
		puts "team_true_shooting"
		puts team_true_shooting
		puts "three_point_att_rate"
		puts team_three_point_att_rate

		puts "(@a * 48 * (@minutes / (@team_minutes/5))"
		puts @a * 48 * (@minutes / (@team_minutes/5))

		puts "@b*off_reb_pct"
		puts @b*off_reb_pct
		puts "@c*def_reb_pct"
		puts @c*def_reb_pct
		puts "@d*steal_pct"
		puts @d*steal_pct
		puts "@e*block_pct"
		puts @e*block_pct
		puts "@f*ast_pct"
		puts @f*ast_pct
		puts "@g*usage_rate *turnover_pct"
		puts @g*usage_rate *turnover_pct
		puts "@h*usage_rate *(1- turnover_pct) * (2*(true_shooting - team_true_shooting) + @i*ast_pct  + @j*(three_point_att_rate - team_three_point_att_rate) - @k)"
		puts @h*usage_rate *(1- turnover_pct) * (2*(true_shooting - team_true_shooting) + @i*ast_pct  + @j*(three_point_att_rate - team_three_point_att_rate) - @k)
		puts "@l * Math.sqrt(ast_pct * total_rebound_pct))"
		puts @l * Math.sqrt(ast_pct * total_rebound_pct)

=end
		raw_bpm = 100 * (@a * 48 * (@minutes / (@team_minutes/5)) + @b*off_reb_pct  + @c*def_reb_pct + @d*steal_pct + @e*block_pct + @f*ast_pct - @g*usage_rate *turnover_pct + @h*usage_rate *(1- turnover_pct) * (2*(true_shooting - team_true_shooting) + @i*ast_pct  + @j*(three_point_att_rate - team_three_point_att_rate) - @k) + @l * Math.sqrt(ast_pct * total_rebound_pct))
		#puts "********************************************** RAW BPM ****************************************************"
		#puts "********************************************** RAW BPM ****************************************************"
		#puts "********************************************** RAW BPM ****************************************************"
		#puts "********************************************** RAW BPM ****************************************************"
		#puts "********************************************** RAW BPM ****************************************************"
		#puts "********************************************** RAW BPM ****************************************************"
		#puts "********************************************** RAW BPM ****************************************************"
		#puts "********************************************** RAW BPM ****************************************************"	
		
		raw_bpm = raw_bpm.round / 100.0
		#puts raw_bpm 
		return raw_bpm

	end

	private 


end

