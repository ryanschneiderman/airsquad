=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Stats::Advanced::TotalReboundPctService
	def initialize(params)
		@total_reb = params[:total_reb]
		@team_minutes_played = params[:team_minutes]
		@minutes_played = params[:minutes]
		@team_total_reb = params[:team_total_reb]
		@opp_total_reb = params[:opp_total_reb]
	end

	def call()
		if (@minutes_played * (@team_total_reb + @opp_total_reb)) == 0
			return 0.0
		else 
			raw_trb = 100 * 100 * (@total_reb * (@team_minutes_played / 5)) / (@minutes_played * (@team_total_reb + @opp_total_reb))
			trb = raw_trb.round / 100.0
			return trb
		end
	end
end




##100 * (TRB * (Tm MP / 5)) / (MP * (Tm TRB + Opp TRB))