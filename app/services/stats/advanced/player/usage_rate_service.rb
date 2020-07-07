=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Stats::Advanced::Player::UsageRateService

	def initialize(params)
		#puts "**** USAGE RATE ****"
		@field_goal_att = params[:field_goal_att]
		#puts "@field_goal_att"
		#puts @field_goal_att
		@turnovers = params[:turnovers]
		#puts "@turnovers"
		#puts @turnovers
		@free_throw_att = params[:free_throw_att]
		#puts "@free_throw_att"
		#puts @free_throw_att
		@team_minutes_played = params[:team_minutes]
		#puts "@team_minutes_played"
		#puts @team_minutes_played
		@minutes_played = params[:minutes]
		#puts "minutes_played"
		#puts @minutes_played
		@team_field_goal_att = params[:team_field_goal_att]
		#puts "team_field_goal_att"
		#puts @team_field_goal_att
		@team_turnovers = params[:team_turnovers]
		#puts "@team_turnovers"
		#puts @team_turnovers
		@team_free_throw_att = params[:team_free_throw_att]
		#puts "@team_free_throw_att"
		#puts @team_free_throw_att

	end

	def call()
		if (@minutes_played * (@team_field_goal_att + @team_turnovers + 0.44 * @team_free_throw_att)) == 0
			return 0.0
		else 
			raw_usg = 100 * 100 * ((@field_goal_att + @turnovers + 0.44 * @free_throw_att) * (@team_minutes_played/5)) / (@minutes_played * (@team_field_goal_att + @team_turnovers + 0.44 * @team_free_throw_att))
			((4 + 0 + 0.44 * 2) * (18.75/5)) / (3.75 * (12 + 1 + 0.44 * 6))
			(18.3) / (58.65)
			usg = raw_usg.round / 100.0	
			return usg
		end
	end
end

