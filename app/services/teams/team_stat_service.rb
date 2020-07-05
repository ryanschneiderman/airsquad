class Teams::TeamStatService
	def initialize(params)
		@team_stats = params[:team_stats]
		@team_id = params[:team_id]
	end

	def call
		(@team_stats || []).each do |stat_id|
			TeamStat.create(
				stat_list_id: stat_id,
				team_id: @team_id,
				show: true,
			)
		end
	end
end