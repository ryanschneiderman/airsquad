=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Stats::Advanced::Team::PossessionsService
	def initialize(params)
		@team_field_goal_att = params[:team_field_goal_att]
		@team_free_throw_att = params[:team_free_throw_att]
		@team_turnovers = params[:team_turnovers]
		@team_off_reb = params[:team_off_reb]

	end

	def call()
		raw_poss = 100 * 0.96 * (@team_field_goal_att + 0.44 * @team_free_throw_att + @team_turnovers - @team_off_reb)
		poss = raw_poss.round / 100.0
		return poss
	end
end


