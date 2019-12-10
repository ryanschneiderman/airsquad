=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Advanced::AssistPctService
	def initialize(params)
		@assists = params[:assists]
		puts "assists"
		puts @assists
		@minutes_played = params[:minutes]
		puts "@minutes_played"
		puts @minutes_played
		@team_minutes_played = params[:team_minutes]
		puts "@team_minutes"
		puts @team_minutes_played
		@team_field_goals = params[:team_field_goals]
		puts "team_field_goals"
		puts @team_field_goals
		@field_goals = params[:field_goals]
		puts "@field_goals"
		puts @field_goals

	end

	def call()
		if @minutes_played || @team_minutes_played == 0
			return 0.0
		else
			if (((@minutes_played / (@team_minutes_played / 5)) * @team_field_goals) - @field_goals) == 0
				return 0.0
			else
				raw_ast = 100 * 100 * @assists / (((@minutes_played / (@team_minutes_played / 5)) * @team_field_goals) - @field_goals)
				ast = raw_ast.round / 100.0
				return ast
			end
		end

	end
end

## 100 * AST / (((MP / (Tm MP / 5)) * Tm FG) - FG)