=begin
(Assists)*100/[(Field Goal Attempts)+(Free Throw Attempts*0.44)+(Assists)+(Turnovers)]
=end

class Stats::Advanced::Team::AssistRatioService
	def initialize(params)
		@assists = params[:assists]
		@possessions = params[:possessions]
	end

	def call()
		if @possessions == 0 
			return 0.0
		else
			raw_ast = 100 * 100 * @assists / @possessions
			ast = raw_ast.round / 100.0
			return ast
		end

	end
end