
class Stats::FixFtRateService

	def initialize(params)
		@team_id = params[:team_id]
	end

	def call
		@season_ftr = SeasonTeamAdvStat.where(stat_list_id: 47, team_id: @team_id, is_opponent: false).take
		puts @season_ftr.constituent_stats
	end

	private

	
end
