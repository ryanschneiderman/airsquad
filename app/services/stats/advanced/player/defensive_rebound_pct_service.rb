=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end


class Stats::Advanced::Player::DefensiveReboundPctService
	def initialize(params)
		@def_reb = params[:def_reb]
		@opp_off_reb = params[:opp_off_reb]
		@team_minutes = params[:team_minutes]
		@minutes = params[:minutes]
		@team_def_reb = params[:team_def_reb]
	end

	def call()
		if (@minutes * (@team_def_reb + @opp_off_reb)) == 0
			return 0.0
		else 
			raw_dreb = 100 * 100 * (@def_reb * (@team_minutes / 5)) / (@minutes * (@team_def_reb + @opp_off_reb))
			dreb = raw_dreb.round / 100.0
			return dreb
		end
	end
end
