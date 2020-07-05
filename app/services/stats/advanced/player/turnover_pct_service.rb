=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Stats::Advanced::Player::TurnoverPctService
	def initialize(params)
		@turnovers = params[:turnovers]
		@field_goal_att = params[:field_goal_att]
		@free_throw_att = params[:free_throw_att]
	end

	def call()
		if (@field_goal_att + 0.44 * @free_throw_att + @turnovers) == 0
			return 0.0
		else
			raw_tov = 100 * @turnovers / (@field_goal_att + 0.44 * @free_throw_att + @turnovers) * 100 
			tov = raw_tov.round / 100.0
			return tov
		end
	end
end

## 100 * TOV / (FGA + 0.44 * FTA + TOV)