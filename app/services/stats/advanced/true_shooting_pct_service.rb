=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Stats::Advanced::TrueShootingPctService
	def initialize(params)
		@points = params[:points]
		@field_goal_att = params[:field_goal_att]
		@free_throw_att = params[:free_throw_att]
	end

	def call()
		if @field_goal_att == 0 && @free_throw_att == 0
			return 0.0
		else 
			raw_ts = 100 * 100 * @points / (2 * (@field_goal_att + 0.44 * @free_throw_att))
			ts = raw_ts.round / 100.0
			return ts
		end
	end

end
