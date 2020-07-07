=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Stats::Advanced::Player::OffensiveRatingService
	def initialize(params)
		@team_off_reb = params[:team_off_reb] 
		@off_reb = params[:off_reb]
		@opponent_trb = params[:opp_total_reb] 
		@opponent_off_reb = params[:opp_off_reb]
		@field_goals_made = params[:field_goals] 
		@team_field_goals_made = params[:team_field_goals] 
		@team_three_ptm = params[:team_three_point_fg]
		@three_pm = params[:three_point_fg]
		@points = params[:points] 
		@team_points = params[:team_points] 
		@free_throw_att = params[:free_throw_att]
		@free_throws_made = params[:free_throw_makes]
		@team_free_throw_att = params[:team_free_throw_att] 
		@team_free_throws_made = params[:team_free_throw_makes]
		@field_goal_att = params[:field_goal_att] 
		@team_field_goal_att = params[:team_field_goal_att] 
		@minutes = params[:minutes]
		@team_minutes = params[:team_minutes] 
		@team_assists = params[:team_assists] 
		@assists = params[:assists]
		@turnovers = params[:turnovers]
		@team_turnovers = params[:team_turnovers]
		#puts "team minutes in orating"
		#puts @team_minutes

	end

	def call()
		@qassists = get_qassists()

		#puts "@qassists"
		#puts @qassists

		@fg_part = get_fg_part()
		#puts "@fg_part"
		#puts @fg_part

		@assists_part = get_assists_part()
		#puts "@assists_part"
		#puts @assists_part


		@ft_part = get_ft_part()
		#puts "@ft_part"
		#puts @ft_part

		@team_scoring_poss = get_team_scoring_poss()

		#puts "@team_scoring_poss"
		#puts @team_scoring_poss

		@team_off_reb_pct = get_team_off_reb_pct()
		#puts "@team_off_reb_pct"
		#puts @team_off_reb_pct
		@team_play_pct = get_team_play_pct()
		#puts "@team_play_pct"
		#puts @team_play_pct
		@team_off_reb_weight = get_team_off_reb_weight()
		#puts "@team_off_reb_weight"
		#puts @team_off_reb_weight
		@off_reb_part = get_off_reb_part()
		#puts "@off_reb_part"
		#puts @off_reb_part
		@sc_poss = get_sc_poss()

		#puts "sc_poss"
		#puts @sc_poss


		@fg_x_poss = get_fg_x_poss()

		@ft_x_poss = get_ft_x_poss()

		@tot_poss = get_tot_poss()
		
		@pprod_fg_part = get_pprod_fg_part()

		@pprod_asst_part = get_pprod_asst_part()

		@pprod_off_reb_part = get_pprod_off_reb_part()

		@pprod = get_pprod()
		#puts "PPROD"
		#puts @pprod

		#puts "tot_poss"
		#puts @tot_poss

		if @tot_poss == 0 
			return 0.0
		else 
			raw_off_rtg = 100 * (@pprod / @tot_poss) * 100
			off_rtg = raw_off_rtg.round / 100.0
			return off_rtg
		end
	end

	private
	## CORRECT
	def get_qassists()
		#puts "@minutes"
		#puts @minutes
		#puts "@team_minutes"
		#puts @team_minutes
		#puts "@assists"
		#puts @assists
		#puts "@team_assists"
		#puts @team_assists
		#puts "@team_field_goals_made"
		#puts @team_field_goals_made
		#puts "@field_goals_made"
		#puts @field_goals_made
		#puts "Pre qassists"
		val_1 = (@minutes / (@team_minutes / 5))
		#puts val_1
		val_2 = (1.14 * ((@team_assists - @assists) / @team_field_goals_made ))
		#puts val_2
		val_3 = ((@team_assists / @team_minutes) * @minutes * 5 - @assists)
		#puts val_3
		val_4 = ((@team_field_goals_made / @team_minutes) * @minutes * 5 - @field_goals_made)
		#puts val_4
		val_5 = (1 -  (@minutes / (@team_minutes / 5)))
		#puts val_5

		if val_4 == 0
			val_4 = 0.01
		end
		#puts (val_1 * val_2) + ((val_3 / val_4) * val_5)


		###puts (( @minutes / (@team_minutes / 5)) * (1.14 * ((@team_assists - @assists) / @team_field_goals_made ))) + ((((@team_assists / @team_minutes) * @minutes * 5 - @assists) / ((@team_field_goals_made / @team_minutes) * @minutes * 5 - @field_goals_made)) *  (1 -  (@minutes / (@team_minutes / 5))))
		return (val_1 * val_2) + ((val_3 / val_4) * val_5)
	end
	## CORRECT
	def get_fg_part()

		if @field_goal_att == 0
			return 0.0
		else 
			return @field_goals_made * (1 - 0.5 * ((@points - @free_throws_made) / (2 * @field_goal_att)) * @qassists)
		end
	end
	## CORRECT
	def get_assists_part()
		if (@team_field_goal_att - @field_goal_att) == 0
			fg_diff = 1
		else fg_diff = (@team_field_goal_att - @field_goal_att)
		end
		return 0.5 * (((@team_points - @team_free_throws_made) - (@points - @free_throws_made)) / (2 * (fg_diff))) * @assists
	end
	## CORRECT 
	def get_ft_part()
		if @free_throw_att == 0
			return 0.0
		else 
			return (1-(1-(@free_throws_made/@free_throw_att))**2) * 0.4 * @free_throw_att
		end
	end
	## CORRECT
	def get_team_scoring_poss()
		if @team_free_throw_att == 0
			ft_quot = 0
		else 
			ft_quot = (1-(1-(@team_free_throws_made/@team_free_throw_att))**2)
		end
		return @team_field_goals_made + ft_quot * @team_free_throw_att * 0.4
	end
	## CORRECT
	def get_team_off_reb_pct()
		if @team_off_reb + (@opponent_trb - @opponent_off_reb) == 0
			return 0.0 
		else 
			return @team_off_reb / (@team_off_reb + (@opponent_trb - @opponent_off_reb))
		end
	end
	## CORRECT
	def get_team_play_pct ()
		if @team_field_goal_att + @team_free_throw_att * 0.4 + @team_turnovers == 0
			return 0.0
		else 
			return @team_scoring_poss / (@team_field_goal_att + @team_free_throw_att * 0.4 + @team_turnovers)
		end
	end
	## CORRECT
	def get_team_off_reb_weight()
		if ((1 - @team_off_reb_pct) * @team_play_pct + @team_off_reb_pct * (1 - @team_play_pct)) == 0
			return 0
		else
			return ((1 - @team_off_reb_pct) * @team_play_pct) / ((1 - @team_off_reb_pct) * @team_play_pct + @team_off_reb_pct * (1 - @team_play_pct))
		end
	end
	## CORRECT
	def get_off_reb_part()
		return @off_reb * @team_off_reb_weight * @team_play_pct
	end
	## CORRECT
	def get_sc_poss()
		return (@fg_part + @assists_part + @ft_part) * (1 - (@team_off_reb / @team_scoring_poss) * @team_off_reb_weight * @team_play_pct) + @off_reb_part
	end
	## CORRECT
	def get_fg_x_poss()
		return (@field_goal_att - @field_goals_made) * (1 - 1.07 * @team_off_reb_pct)
	end
	## CORRECT
	def get_ft_x_poss()
		if @free_throw_att == 0
			return 0.0
		else
			return ((1 - (@free_throws_made / @free_throw_att))**2) * 0.4 * @free_throw_att
		end
	end
	## CORRECT
	def get_tot_poss()
		return @sc_poss + @fg_x_poss + @ft_x_poss + @turnovers
	end
	## CORRECT
	def get_pprod_fg_part()
		if @field_goal_att == 0 
			return 0.0
		else 
			return  2 * (@field_goals_made + 0.5 * @three_pm) * (1 - 0.5 * ((@points - @free_throws_made) / (2 * @field_goal_att)) * @qassists)
		end
	end
	## CORRECT
	def get_pprod_asst_part()
		if @team_field_goals_made - @field_goals_made == 0
			fg_quot = 1
		else
			fg_quot = (@team_field_goals_made - @field_goals_made)
		end
		if (@team_field_goal_att - @field_goal_att) == 0 
			fg_att_quot = 1
		else 
			fg_att_quot = (@team_field_goal_att - @field_goal_att)
		end
		return 2 * ((@team_field_goals_made - @field_goals_made + 0.5 * (@team_three_ptm - @three_pm)) / fg_quot) * 0.5 * (((@team_points - @team_free_throws_made) - (@points - @free_throws_made)) / (2 * fg_att_quot)) * @assists
	end

	def get_pprod_off_reb_part()
		if @team_free_throw_att == 0
			ft_att_rate = 0
		else
			ft_att_rate = (@team_free_throws_made / @team_free_throw_att)
		end
		if (@team_field_goals_made + (1 - (1 - ft_att_rate)**2) * 0.4 * @team_free_throw_att) == 0
			big_quot = 1
		else 
			big_quot = (@team_field_goals_made + (1 - (1 - ft_att_rate)**2) * 0.4 * @team_free_throw_att)
		end 
		return @off_reb * @team_off_reb_weight * @team_play_pct * (@team_points / big_quot)
	end

	def get_pprod()
		if @team_scoring_poss == 0
			quot = 0
		else 
			quot = (@team_off_reb / @team_scoring_poss)
		end 
		return (@pprod_fg_part + @pprod_asst_part + @free_throws_made) * (1 - quot * @team_off_reb_weight * @team_play_pct) + @pprod_off_reb_part
	end
end