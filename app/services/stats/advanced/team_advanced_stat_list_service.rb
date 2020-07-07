class Stats::Advanced::TeamAdvancedStatListService
	def initialize(params)
		@team_id = params[:team_id]
	end

	def call()
		team_advanced_stats = []
		team_advanced_stat_list = TeamStat.where(team_id: @team_id).joins(:stat_list).where('stat_lists.advanced' => true);
		team_advanced_stat_list.each do |stat|
			team_advanced_stats.push(StatList.find_by_id(stat.stat_list_id))
		end
		stat_table_columns = Stats::StatTableColumnsService.new({
			stats: team_advanced_stats,
			is_advanced: true,
			is_team: true,
		}).call
		return stat_table_columns
	end
end