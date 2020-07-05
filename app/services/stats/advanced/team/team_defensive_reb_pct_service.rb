class Stats::Advanced::Team::TeamDefensiveRebPctService
	def initialize(params)
		@team_def_reb = params[:team_def_reb]
		@opp_off_reb = params[:opp_off_reb]
	end

	def call()
		if @team_def_reb + @opp_off_reb == 0 
			raw_dreb_pct = 0.0 
		else
			raw_dreb_pct = 100 * 100 * @team_def_reb / (@team_def_reb + @opp_off_reb)
		end
		dreb_pct = raw_dreb_pct.round / 100.0
		return dreb_pct
	end
end