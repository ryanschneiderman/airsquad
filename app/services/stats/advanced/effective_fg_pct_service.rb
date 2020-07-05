=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Stats::Advanced::EffectiveFgPctService
	def initialize(params)
		@field_goals = params[:field_goals]
		@field_goal_att = params[:field_goal_att]
		@three_point_fg = params[:three_point_fg]
	end

	def call()
		if @field_goal_att == 0.0
			return 0.0
		else 
			raw_efg = 100 * (@field_goals + 0.5 * @three_point_fg) / @field_goal_att * 100
			efg = raw_efg.round / 100.0
			return efg
		end
	end

end