=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Stats::Advanced::Player::OffensiveReboundPctService
	def initialize(params)
		@off_reb = params[:off_reb]
		@opp_def_reb = params[:opp_def_reb]
		@team_minutes = params[:team_minutes]
		@minutes = params[:minutes]
		@team_off_reb = params[:team_off_reb]
	end

	def call()
		if @minutes * (@team_off_reb + @opp_def_reb) == 0
			return 0.0
		else
			raw_oreb = 100 * 100 * (@off_reb * (@team_minutes / 5)) / (@minutes * (@team_off_reb + @opp_def_reb))
			return raw_oreb.round / 100.0
		end
	end

end
