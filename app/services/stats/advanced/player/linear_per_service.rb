=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Stats::Advanced::Player::LinearPerService
	def initialize(params)
		@field_goals = params[:field_goals]
		@steals = params[:steals]
		@three_point_makes = params[:three_point_makes]
		@free_throw_makes = params[:free_throw_makes]
		@blocks = params[:blocks]
		@off_reb = params[:off_reb]
		@assists = params[:assists]
		@def_reb = params[:def_reb]
		@fouls = params[:fouls]
		@free_throw_misses = params[:free_throw_misses]
		@field_goal_misses = params[:field_goal_misses]
		@turnovers = params[:turnovers]
		@minutes = params[:minutes]
	end

	def call()
		if @minutes == 0
			return 0.0
		else 
			raw_per = 100 * (((@field_goals * 85.910) + (@steals * 53.897) + (@three_point_makes * 51.757) + (@free_throw_makes * 46.845) + (@blocks * 39.190) + (@off_reb * 39.190) + (@assists * 34.677) + (@def_reb * 14.707) - (@fouls * 17.174) - (@free_throw_misses * 20.091) - (@field_goal_misses * 39.190) - @turnovers * 53.897) / @minutes)
			per = raw_per.round / 100.0	
			return per
		end
	end
end