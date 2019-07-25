class Stats::CollectableStatsService
	def initialize(params)
		@stats = params[:stats]
	end

	def call
		@display_stats = []
		@stats.each do |stat|
			determine_display_name(stat)
		end
		return @display_stats
	end


	private 

	def determine_display_name(stat)
		case stat.id
		when 1
			@display_stats.push({:display_name => "Make", :id => stat.id})
		when 2
			@display_stats.push({:display_name => "Miss", :id => stat.id})
		when 3
			@display_stats.push({:display_name => "Assist", :id => stat.id})
		when 4
			@display_stats.push({:display_name => "Offensive Rebound", :id => stat.id})
		when 5
			@display_stats.push({:display_name => "Defenisve Rebound", :id => stat.id})
		when 6
			@display_stats.push({:display_name => "Steal", :id => stat.id})
		when 7
			@display_stats.push({:display_name => "Turnover", :id => stat.id})
		when 8 
			@display_stats.push({:display_name => "Block", :id => stat.id})
		when 13
			@display_stats.push({:display_name => "FT Make", :id => stat.id})
		when 14
			@display_stats.push({:display_name => "FT Miss", :id => stat.id})
		when 17
			@display_stats.push({:display_name => "Foul", :id => stat.id})
		end
	end
end