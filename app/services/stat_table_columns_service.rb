class StatTableColumnsService

	def initialize(params)
		@stats = params[:stats]
		@is_advanced = params[:is_advanced]
	end


	def call
		if !@is_advanced
			@display_stats = [{:stat_name => "FG", :display_priority => 1, :display_type => "fraction", :percentage_string => "FG%"}, {:stat_name =>"2pt FG", :display_priority => 3, :display_type => "fraction", :percentage_string => "2pt%"}, {:stat_name =>"3pt FG", :display_priority => 5, :display_type => "fraction", :percentage_string => "3pt%"}, {:stat_name =>"FT", :display_priority => 7, :display_type => "fraction", :percentage_string => "FT%"}, {:stat_name =>"Points", :display_priority => 15, :display_type => "standard"}, {:stat_name =>"Fouls", :display_priority => 16, :display_type => "standard"}, {:stat_name =>"Minutes", :display_priority => 17, :display_type => "minutes"}]
			@stats.each do |stat|
				determine_display_name_basic(stat.stat)
			end
		else
			@display_stats =[]
			@stats.each do |stat|
				determine_display_name_adv(stat.stat)
			end
		end
		
		@sorted = @display_stats.sort_by{|e| e[:display_priority]}
		return @sorted
	end

	private

	def determine_display_name_basic(stat_name)
		case stat_name
		when "Assist"
			@display_stats.push({:stat_name =>"Assists", :display_priority => 9, :display_type => "standard"})
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

	def determine_display_name_adv(stat_name)
		case stat_name
		when "Effective field goal %"
			@display_stats.push({:display_name => "EFG%", :display_priority => 1, :stat_name => stat_name})
		when "True shooting %"
			@display_stats.push({:display_name => "TS%", :display_priority => 2, :stat_name => stat_name})
		when "3 point attempt rate"
			@display_stats.push({:display_name => "3PAr", :display_priority => 3, :stat_name => stat_name})
		when "Free throw attempt rate"
			@display_stats.push({:display_name => "FTAr", :display_priority => 4, :stat_name => stat_name})
		when "Assist %"
			@display_stats.push({:display_name => "AST%", :display_priority => 5, :stat_name => stat_name})
		when "Turnover %"
			@display_stats.push({:display_name => "TOV%", :display_priority => 6, :stat_name => stat_name})
		when "Offensive Rebound %"
			@display_stats.push({:display_name => "ORB%", :display_priority => 7, :stat_name => stat_name})
		when "Defensive Rebound %"
			@display_stats.push({:display_name => "DRB%", :display_priority => 8, :stat_name => stat_name})
		when "Total Rebound %"
			@display_stats.push({:display_name => "TRB%", :display_priority => 9, :stat_name => stat_name})
		when "Steal %"
			@display_stats.push({:display_name => "STL%", :display_priority => 10, :stat_name => stat_name})
		when "Block %"
			@display_stats.push({:display_name => "BLK%", :display_priority => 11, :stat_name => stat_name})
		when "Usage rate"
			@display_stats.push({:display_name => "USG%", :display_priority => 12, :stat_name => stat_name})
		when "Offensive rating"
			@display_stats.push({:display_name => "ORtg", :display_priority => 13, :stat_name => stat_name})
		when "Defensive rating"
			@display_stats.push({:display_name => "DRtg", :display_priority => 14, :stat_name => stat_name})
		when "Net rating"
			@display_stats.push({:display_name => "NetRtg", :display_priority => 15, :stat_name => stat_name})
		when "Linear Player Efficiency Rating"
			@display_stats.push({:display_name => "LinPER", :display_priority => 16, :stat_name => stat_name})
		when "Offensive Box Plus Minus"
			@display_stats.push({:display_name => "OBPM", :display_priority => 17, :stat_name => stat_name})
		when "Defenisve Box Plus Minus"
			@display_stats.push({:display_name => "DBPM", :display_priority => 18, :stat_name => stat_name})
		when "Box Plus Minus"
			@display_stats.push({:display_name => "BPM", :display_priority => 19, :stat_name => stat_name})
		end
	end

end