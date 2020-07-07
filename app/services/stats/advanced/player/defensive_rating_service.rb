=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end


class Stats::Advanced::Player::DefensiveRatingService

	def initialize(params)
		@steals = params[:steals]
		#puts @steals
		@team_steals = params[:team_steals]
		#puts @team_steals
		@blocks = params[:blocks]
		#puts @blocks
		@team_blocks = params[:team_blocks]
		#puts @team_blocks
		@def_reb = params[:def_reb]
		#puts @def_reb
		@team_def_reb = params[:team_def_reb]
		#puts @team_def_reb
		@opp_off_reb = params[:opp_off_reb]
		#puts @opp_off_reb
		@opp_field_goals_made = params[:opp_field_goals_made]
		#puts @opp_field_goals_made
		@opp_field_goal_att = params[:opp_field_goal_att]
		#puts @opp_field_goal_att
		@team_minutes = params[:team_minutes]
		#puts @team_minutes
		@minutes = params[:minutes]
		#puts @minutes
		@opp_minutes = params[:opp_minutes]
		#puts @opp_minutes
		@opp_turnovers = params[:opp_turnovers]
		#puts @opp_turnovers
		@fouls = params[:fouls]
		#puts @fouls
		@team_fouls = params[:team_fouls]
		#puts @team_fouls
		@opp_free_throw_att = params[:opp_free_throw_att]
		#puts @opp_free_throw_att
		@opp_free_throws_made = params[:opp_free_throws_made]
		#puts @opp_free_throws_made

		@opp_possessions = params[:opp_possessions]
		#puts @opp_possessions
		@opp_points = params[:opp_points]
		#puts @opp_points

	end

	def call()
		if (@opp_off_reb + @team_def_reb) == 0
			dor_pct = 0
		else 
			dor_pct = @opp_off_reb / (@opp_off_reb + @team_def_reb)
		end

		#puts "dor_pct"
		#puts dor_pct

		if @opp_field_goal_att == 0 
			dfg_pct = 0
		else 
			dfg_pct = @opp_field_goals_made / @opp_field_goal_att
		end

		#puts "dfg_pct"
		#puts dfg_pct

		if dfg_pct == 0 && dor_pct == 0
			fm_wt = 1
		else
			fm_wt = (dfg_pct * (1 - dor_pct)) / (dfg_pct * (1 - dor_pct) + (1 - dfg_pct) * dor_pct)
		end

		stops_a = @steals + @blocks * fm_wt * (1 - 1.07 * dor_pct) + @def_reb * (1 - fm_wt)

		#puts "stops a"
		#puts stops_a

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
		#puts "stops"
		#puts stops
		#puts "@opp_minutes"
		#puts @opp_minutes
		#puts "@opp_possessions"
		#puts @opp_possessions
		#puts "@minutes"
		#puts @minutes
		if @opp_possessions == 0
			return 0.0
		else
			if @minutes == 0 || @opp_possessions == 0
				stop_pct = 0.0
			else 
				stop_pct = (stops * @opp_minutes) / (@opp_possessions * @minutes)
			end

			team_def_rtg = 100 * (@opp_points / @opp_possessions)

			d_points_per_scposs = @opp_points / (@opp_field_goals_made + (1 - (1 - (opp_free_throw_quot))**2) * @opp_free_throw_att*0.4)

			raw_def_rtg = (team_def_rtg + 0.2 * (100 * d_points_per_scposs * (1 - stop_pct) - team_def_rtg)) * 100
			def_rtg = raw_def_rtg.round / 100.0
			return def_rtg
		end
	end

end


