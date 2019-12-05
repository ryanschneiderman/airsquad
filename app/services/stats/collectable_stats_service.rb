class Stats::CollectableStatsService
	def initialize(params)
		@stats = params[:stats]
	end

	def call ()
		@display_stats = []
		@stats.each do |stat|
			determine_display_name(stat)
		end
		return @display_stats.sort_by{|stat| [stat[:stat_kind], stat[:id]]}
	end


	private 

	def determine_display_name(stat)
		case stat.id
		when 1
			@display_stats.push({:display_name => "Make", :id => stat.id, :stat_kind => stat.stat_kind})
		when 2
			@display_stats.push({:display_name => "Miss", :id => stat.id, :stat_kind => stat.stat_kind})
		when 3
			@display_stats.push({:display_name => "Assist", :id => stat.id, :stat_kind => stat.stat_kind})
		when 4
			@display_stats.push({:display_name => "Offensive Rebound", :id => stat.id, :stat_kind => stat.stat_kind})
		when 5
			@display_stats.push({:display_name => "Defensive Rebound", :id => stat.id, :stat_kind => stat.stat_kind})
		when 6
			@display_stats.push({:display_name => "Steal", :id => stat.id, :stat_kind => stat.stat_kind})
		when 7
			@display_stats.push({:display_name => "Turnover", :id => stat.id, :stat_kind => stat.stat_kind})
		when 8 
			@display_stats.push({:display_name => "Block", :id => stat.id, :stat_kind => stat.stat_kind})
		when 13
			@display_stats.push({:display_name => "FT Make", :id => stat.id, :stat_kind => stat.stat_kind})
		when 14
			@display_stats.push({:display_name => "FT Miss", :id => stat.id, :stat_kind => stat.stat_kind})
		when 17
			@display_stats.push({:display_name => "Foul", :id => stat.id, :stat_kind => stat.stat_kind})
		when 51
			@display_stats.push({:display_name => "Deflection", :id => stat.id, :stat_kind => stat.stat_kind})
		end
	end
end