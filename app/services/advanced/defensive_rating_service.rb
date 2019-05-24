=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end


class Advanced::DefensiveRatingService

	def initialize(params)
		@steals = params[:steals]
		@team_steals = params[:team_steals]
		@blocks = params[:blocks]
		@team_blocks = params[:team_blocks]
		@def_reb = params[:def_reb]
		@team_def_reb = params[:team_def_reb]
		@opp_off_reb = params[:opp_off_reb]
		@opp_field_goals_made = params[:opp_field_goals_made]
		@opp_field_goal_att = params[:opp_field_goal_att]
		@team_minutes = params[:team_minutes]
		@minutes = params[:minutes]
		@opp_minutes = params[:opp_minutes]
		@opp_turnovers = params[:opp_turnovers]
		@fouls = params[:fouls]
		@team_fouls = params[:team_fouls]
		@opp_free_throw_att = params[:opp_free_throw_att]
		@opp_free_throws_made = params[:opp_free_throws_made]

		@opp_possessions = Advanced::PossessionsService.new({
			team_field_goal_att: @opp_field_goal_att,
			team_free_throw_att: @opp_free_throw_att,
			team_turnovers: @opp_turnovers,
			team_off_reb: @opp_off_reb
		}).call
		@opp_points = params[:opp_points]

	end

	def call()
		if (@opp_off_reb + @team_def_reb) == 0
			dor_pct = 0
		else 
			dor_pct = @opp_off_reb / (@opp_off_reb + @team_def_reb)
		end

		if @opp_field_goal_att == 0 
			dfg_pct = 0
		else 
			dfg_pct = @opp_field_goals_made / @opp_field_goal_att
		end

		fm_wt = (dfg_pct * (1 - dor_pct)) / (dfg_pct * (1 - dor_pct) + (1 - dfg_pct) * dor_pct)

		stops_a = @steals + @blocks * fm_wt * (1 - 1.07 * dor_pct) + @def_reb * (1 - fm_wt)

		if @opp_free_throw_att == 0 
			opp_free_throw_quot = 0
		else
			opp_free_throw_quot = @opp_free_throws_made / @opp_free_throw_att
		end

		if @team_fouls == 0
			foul_quot = 0.0
		else 
			foul_quot = @fouls / @team_fouls
		end

		stops_b = (((@opp_field_goal_att - @opp_field_goals_made - @team_blocks) / @team_minutes) * fm_wt * (1 - 1.07 * dor_pct) + ((@opp_turnovers - @team_steals) / @team_minutes)) * @minutes +(foul_quot) * 0.4 * @opp_free_throw_att * (1 - (opp_free_throw_quot))**2

		stops = stops_a+stops_b
		if @opp_possessions == 0
			return 0.0
		else
			puts "stops"
			puts stops

			puts "opp_minutes"
			puts @opp_minutes

			puts "opp_possessions"
			puts @opp_possessions

			if @minutes == 0 || @opp_possessions == 0
				stop_pct = 0.0
			else 
				stop_pct = (stops * @opp_minutes) / (@opp_possessions * @minutes)
			end

			puts "stop_pct"
			puts stop_pct

			team_def_rtg = 100 * (@opp_points / @opp_possessions)
			puts "team_def_rtg"
			puts team_def_rtg

			d_points_per_scposs = @opp_points / (@opp_field_goals_made + (1 - (1 - (opp_free_throw_quot))**2) * @opp_free_throw_att*0.4)
			puts "d_points_per_scposs"
			puts d_points_per_scposs

			raw_def_rtg = (team_def_rtg + 0.2 * (100 * d_points_per_scposs * (1 - stop_pct) - team_def_rtg)) * 100
			def_rtg = raw_def_rtg.round/100.0
			return def_rtg
		end
	end

end


