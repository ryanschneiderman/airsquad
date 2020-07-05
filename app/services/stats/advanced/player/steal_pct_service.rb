=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Stats::Advanced::Player::StealPctService
	def initialize(params)
		@steals = params[:steals]
		@team_minutes_played = params[:team_minutes]
		@minutes_played = params[:minutes]
		@opp_poss = params[:opp_poss]
	end

	def call()
		if (@minutes_played * @opp_poss) == 0
			return 0.0
		else
			raw_stl = 100 * (@steals * (@team_minutes_played / 5)) / (@minutes_played * @opp_poss) * 100
			stl = raw_stl.round / 100.0
			return stl
		end
	end
end
