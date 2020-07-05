=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Stats::Advanced::Team::OffensiveEfficiencyService
	def initialize(params)
		@possessions = params[:possessions]
		@team_points = params[:team_points]
	end

	def call()
		if @possessions == 0
			return 0.0
		else
			raw_oeff = 100*(@team_points/@possessions) * 100
			oeff = raw_oeff.round / 100.0
			return oeff
		end
	end

end