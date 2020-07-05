=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Stats::Advanced::Team::DefensiveEfficiencyService
	def initialize(params)
		@possessions = params[:opp_possessions]
		@opp_points = params[:opp_points]
	end

	def call()
		if @possessions == 0
			return 0.0
		else 
			raw_deff = 100*(@opp_points/@possessions) * 100
			deff = raw_deff.round / 100.0
			return deff
		end
	end

end