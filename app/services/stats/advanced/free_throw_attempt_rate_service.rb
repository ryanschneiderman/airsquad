=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Stats::Advanced::FreeThrowAttemptRateService
	def initialize(params)
		@free_throw_att = params[:free_throw_att]
		@field_goal_att = params[:field_goal_att]
	end

	def call()
		if @field_goal_att == 0 && @free_throw_att > 0
			return 100.0
		elsif @field_goal_att == 0 && @free_throw_att == 0
			return 0.0
		else
			raw_ftar = 100 * @free_throw_att/@field_goal_att * 100
			ftar = raw_ftar.round / 100.0
			return ftar
		end
	end
end