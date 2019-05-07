class StatTableColumnsService

	def initialize(params)
		@stats = params[:stats]
	end


	def call
		@display_stats = [{:stat_name => "FG", :display_priority => 1, :display_type => "fraction", :percentage_string => "FG%"}, {:stat_name =>"2pt FG", :display_priority => 3, :display_type => "fraction", :percentage_string => "2pt%"}, {:stat_name =>"3pt FG", :display_priority => 5, :display_type => "fraction", :percentage_string => "3pt%"}, {:stat_name =>"FT", :display_priority => 7, :display_type => "fraction", :percentage_string => "FT%"}, {:stat_name =>"Points", :display_priority => 15, :display_type => "standard"}, {:stat_name =>"Fouls", :display_priority => 16, :display_type => "standard"}, {:stat_name =>"Minutes", :display_priority => 17, :display_type => "minutes"}]
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
			@display_stats.push({:stat_name =>"Rebounds", :display_priority => 9, :display_type => "standard"})
		when "Offensive rebound"
			@display_stats.push({:stat_name =>"O - Rebounds", :display_priority => 10, :display_type => "standard"})
		when "Defensive rebound"
			@display_stats.push({:stat_name =>"D - Rebounds", :display_priority => 11, :display_type => "standard"})
		when "Steal"
			@display_stats.push({:stat_name =>"Steals", :display_priority => 12, :display_type => "standard"})
		when "Block"
			@display_stats.push({:stat_name =>"Blocks", :display_priority => 13, :display_type => "standard"})
		when "Turnover"
			@display_stats.push({:stat_name =>"Turnovers", :display_priority => 14, :display_type => "standard"})
		end
	end

end