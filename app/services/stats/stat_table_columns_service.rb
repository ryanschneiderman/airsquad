class Stats::StatTableColumnsService

	def initialize(params)
		@stats = params[:stats]
		@is_advanced = params[:is_advanced]
		@is_team = params[:is_team]
	end


	def call
		if !@is_advanced
			@display_stats = [{:stat_name => "FG", :display_priority => 1, :display_type => "fraction", :percentage_string => "FG%", :stat_list_id => 1, :stat_kind => 1}, {:stat_name =>"3pt FG", :display_priority => 5, :display_type => "fraction", :percentage_string => "3pt%", :stat_list_id => 11, :stat_kind => 1}, {:stat_name =>"FT", :display_priority => 7, :display_type => "fraction", :percentage_string => "FT%" , :stat_list_id => 13, :stat_kind => 1}, {:stat_name =>"PTS", :display_priority => 16, :display_type => "standard", :stat_list_id => 15, :stat_kind => 1}, {:stat_name =>"Fouls", :display_priority => 17, :display_type => "standard", :stat_list_id => 17, :stat_kind => 2}, {:stat_name =>"MIN", :display_priority => 18, :display_type => "minutes", :stat_list_id => 16, :stat_kind => 3}]
			@stats.each do |stat|
				determine_display_name_basic(stat)
			end
		elsif @is_team
			@display_stats =[]
			@stats.each do |stat|
				determine_display_name_team_adv(stat)
			end
		else 
			@display_stats =[]
			@stats.each do |stat|
				determine_display_name_adv(stat)
			end
		end
		@sorted = @display_stats.sort_by{|e| e[:display_priority]}
		return @sorted
	end

	private

	def determine_display_name_team_adv(stat)
		case stat.id
		when 18
			@display_stats.push({:display_name=> "EFG%", :display_priority => 1, :is_opponent => false, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
			@display_stats.push({:display_name=> "EFG%", :display_priority => 5, :is_opponent => true, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 38
			@display_stats.push({:display_name => "TOV%", :display_priority => 2, :is_opponent => false, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
			@display_stats.push({:display_name => "TOV%", :display_priority => 6, :is_opponent => true, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 33 
			@display_stats.push({:display_name => "ORB%", :display_priority => 3, :is_opponent => false, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 47 
			@display_stats.push({:display_name => "FT/FGA", :display_priority => 4, :is_opponent => false, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
			@display_stats.push({:display_name => "FT/FGA", :display_priority => 8, :is_opponent => true, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 34 
			@display_stats.push({:display_name => "DRB%", :display_priority => 7, :is_opponent => false, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 22 
			@display_stats.push({:display_name => "FTAr", :display_priority => 9, :is_opponent => false, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 21 
			@display_stats.push({:display_name => "3PAr", :display_priority => 10, :is_opponent => false, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 46 
			@display_stats.push({:display_name => "Pace", :display_priority => 11, :is_opponent => false, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 30 
			@display_stats.push({:display_name => "OEff", :display_priority => 12, :is_opponent => false, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 31 
			@display_stats.push({:display_name => "DEff", :display_priority => 13, :is_opponent => false, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		end

	end

	def determine_display_name_basic(stat)
		case stat.id
		when 3
			@display_stats.push({:stat_name =>"AST", :display_priority => 9, :display_type => "standard", stat_list_id: stat.id, :stat_kind => stat.stat_kind})
		when 4
			@display_stats.push({:stat_name =>"OReb", :display_priority => 10, :display_type => "standard", stat_list_id: stat.id, :stat_kind => stat.stat_kind})
		when 5
			@display_stats.push({:stat_name =>"DReb", :display_priority => 11, :display_type => "standard", stat_list_id: stat.id, :stat_kind => stat.stat_kind})
		when 6
			@display_stats.push({:stat_name =>"STL", :display_priority => 12, :display_type => "standard", stat_list_id: stat.id, :stat_kind => stat.stat_kind})
		when 7
			@display_stats.push({:stat_name =>"TOV", :display_priority => 15, :display_type => "standard", stat_list_id: stat.id, :stat_kind => stat.stat_kind})
		when 8
			@display_stats.push({:stat_name =>"BLK", :display_priority => 14, :display_type => "standard", stat_list_id: stat.id, :stat_kind => stat.stat_kind})
		when 51
			@display_stats.push({:stat_name =>"DFL", :display_priority => 13, :display_type => "standard", stat_list_id: stat.id, :stat_kind => stat.stat_kind})
		end
	end

	def determine_display_name_adv(stat)
		case stat.id
		when 18
			@display_stats.push({:display_name => "EFG%", :display_priority => 1, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 19
			@display_stats.push({:display_name => "TS%", :display_priority => 2, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 21
			@display_stats.push({:display_name => "3PAr", :display_priority => 3, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 22
			@display_stats.push({:display_name => "FTAr", :display_priority => 4, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 39
			@display_stats.push({:display_name => "AST%", :display_priority => 5, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 38
			@display_stats.push({:display_name => "TOV%", :display_priority => 6, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 33
			@display_stats.push({:display_name => "ORB%", :display_priority => 7, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 34
			@display_stats.push({:display_name => "DRB%", :display_priority => 8, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 35
			@display_stats.push({:display_name => "TRB%", :display_priority => 9, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 36
			@display_stats.push({:display_name => "STL%", :display_priority => 10, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 37
			@display_stats.push({:display_name => "BLK%", :display_priority => 11, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 23
			@display_stats.push({:display_name => "USG%", :display_priority => 12, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 24
			@display_stats.push({:display_name => "ORtg", :display_priority => 13, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 25
			@display_stats.push({:display_name => "DRtg", :display_priority => 14, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 26
			@display_stats.push({:display_name => "NetRtg", :display_priority => 15, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 20
			@display_stats.push({:display_name => "LinPER", :display_priority => 16, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 45
			@display_stats.push({:display_name => "uOBPM", :display_priority => 17, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 44
			@display_stats.push({:display_name => "uBPM", :display_priority => 18, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 41
			@display_stats.push({:display_name => "DBPM", :display_priority => 19, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 40
			@display_stats.push({:display_name => "OBPM", :display_priority => 20, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		when 42
			@display_stats.push({:display_name => "BPM", :display_priority => 21, :stat_name => stat.stat, stat_list_id: stat.id, :stat_kind => stat.stat_kind, :stat_description => stat.stat_description})
		end
	end

end