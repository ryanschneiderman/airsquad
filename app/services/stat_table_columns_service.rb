class StatTableColumnsService

	def initialize(params)
		@stats = params[:stats]
	end


	def call
		@display_stats = [{:stat_name => "FG", :display_priority => 1}, {:stat_name =>"FG%", :display_priority => 2}, {:stat_name =>"2pt FG", :display_priority => 3}, {:stat_name =>"2pt%", :display_priority => 4}, {:stat_name =>"3pt FG", :display_priority => 5}, {:stat_name =>"3pt%", :display_priority => 6}, {:stat_name =>"FT", :display_priority => 7}, {:stat_name =>"FT%", :display_priority => 8}, {:stat_name =>"Points", :display_priority => 15}, {:stat_name =>"Fouls", :display_priority => 16}, {:stat_name =>"Minutes", :display_priority => 17}]
		@stats.each do |stat|
			determine_display_name(stat.stat)
		end
		@sorted = @display_stats.sort_by{|e| e[:display_priority]}
		return @sorted
	end

	private

	def determine_display_name(stat_name)
		case stat_name
		when "Rebound"
			@display_stats.push({:stat_name =>"Rebounds", :display_priority => 9})
		when "Offensive rebound"
			@display_stats.push({:stat_name =>"O - Rebounds", :display_priority => 10})
		when "Defensive rebound"
			@display_stats.push({:stat_name =>"D - Rebounds", :display_priority => 11})
		when "Steal"
			@display_stats.push({:stat_name =>"Steals", :display_priority => 12})
		when "Block"
			@display_stats.push({:stat_name =>"Blocks", :display_priority => 13})
		when "Turnover"
			@display_stats.push({:stat_name =>"Turnovers", :display_priority => 14})
		end
	end

end