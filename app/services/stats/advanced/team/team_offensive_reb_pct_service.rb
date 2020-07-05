class Stats::Advanced::Team::TeamOffensiveRebPctService
	def initialize(params)
		@team_off_reb = params[:team_off_reb]
		@opp_def_reb = params[:opp_def_reb]
	end

	def call()
		if @team_off_reb + @opp_def_reb == 0 
			raw_oreb_pct = 0.0
		else
			raw_oreb_pct = 100 * 100 *  @team_off_reb / (@team_off_reb + @opp_def_reb)
		end
		oreb_pct = raw_oreb_pct.round / 100.0
		return oreb_pct
	end
end