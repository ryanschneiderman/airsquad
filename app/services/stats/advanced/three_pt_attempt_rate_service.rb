=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Stats::Advanced::ThreePtAttemptRateService
	def initialize(params)
		@three_point_att = params[:three_point_att]
		@field_goal_att = params[:field_goal_att]
	end

	def call()
		if @field_goal_att == 0
			return 0.0
		else 
			raw_three_ar = 100 * @three_point_att / @field_goal_att * 100
			three_ar = raw_three_ar.round / 100.0
			return three_ar
		end
	end

end


## 3pa/ fga