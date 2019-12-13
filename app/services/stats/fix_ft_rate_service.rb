
class Stats::FixFtRateService

	def initialize(params)
		@team_id = params[:team_id]
	end

	def call
		@season_ftr = SeasonTeamAdvStat.where(stat_list_id: 47, team_id: @team_id, is_opponent: false).take

		puts @season_ftr.constituent_stats
		@season_ftr.value = 100 * (1000 * @season_ftr.constituent_stats["team_free_throw_makes"] / @season_ftr.constituent_stats["team_field_goal_att"]).round / 1000.0
		@season_ftr.save

		@opp_ftr = SeasonTeamAdvStat.where(stat_list_id: 47, team_id: @team_id, is_opponent: true).take
		@opp_ftr.value = 100 * (1000 * @opp_ftr.constituent_stats["team_free_throw_makes"] / @opp_ftr.constituent_stats["team_field_goal_att"]).round / 1000.0
		@opp_ftr.save
	end

	private

	
end
