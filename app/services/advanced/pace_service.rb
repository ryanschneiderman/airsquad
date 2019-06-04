class Advanced::PaceService
	def initialize(params)
		@possessions = params[:possessions]
		@opp_possessions = params[:opp_possessions]
		@team_minutes = params[:team_minutes]
		@minutes_per_game = params[:minutes_per_game]
	end

	def call()
		pace = @minutes_per_game * ((@possessions + @opp_possessions) / (2 * (@team_minutes / 5))) * 100
		pace = pace.round / 100.0
		return pace
	end
end


## 48 * ((Tm Poss + Opp Poss) / (2 * (Tm MP / 5)))