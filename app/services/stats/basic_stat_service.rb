class Stats::BasicStatService
	def initialize(params)
		@team_id = params[:team_id]
	end

	def call()
		basic_stats = []
		basic_team_stats = TeamStat.where(team_id: @team_id).joins(:stat_list).where('stat_lists.advanced' => false, 'stat_lists.team_stat' =>false);
		basic_team_stats.each do |stat|
			basic_stats.push(StatList.find_by_id(stat.stat_list_id))
		end

		stat_table_columns = Stats::StatTableColumnsService.new({
			stats: basic_stats,
			is_advanced: false,
			is_team: false
		}).call
		return stat_table_columns
	end
end



