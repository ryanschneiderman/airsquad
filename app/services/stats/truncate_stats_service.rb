class Stats::TruncateStatsService
	def initialize(params)
		@team_id = params[:team_id]
		@season_id = params[:season_id]
		@members = Member.where(team_id: @team_id, season_id: @season_id)
		@games = Game.where(team_id: @team_id, season_id: @season_id)
		@lineups = Lineup.where(team_id: @team_id, season_id: @season_id)

	end

	def call()
		SeasonTeamAdvStat.where(:team_id => @team_id, season_id: @season_id).destroy_all
		StatTotal.where(:team_id => @team_id, season_id: @season_id).destroy_all
		TeamSeasonStat.where(:team_id => @team_id, season_id: @season_id).destroy_all
		@members.each do |member|
			SeasonAdvancedStat.where(member_id: member.id, season_id: @season_id).destroy_all
			SeasonStat.where(member_id: member.id, season_id: @season_id).destroy_all
		end
		@games.each do |game|
			TeamAdvancedStat.where(game_id: game.id, season_id: @season_id).destroy_all
			AdvancedStat.where(game_id: game.id, season_id: @season_id).destroy_all
			StatGranule.where(game_id: game.id, season_id: @season_id).destroy_all
			Stat.where(game_id: game.id, season_id: @season_id).destroy_all
		end

		@lineups.each do |lineup|
			LineupGameStat.where(lineup_id: lineup.id, season_id: @season_id).destroy_all
			LineupGameAdvancedStat.where(lineup_id: lineup.id, season_id: @season_id).destroy_all
			LineupStat.where(lineup_id: lineup.id)
			Lineup.find_by_id(lineup.id).destroy
		end

		Member.where(:team_id => @team_id, season_id: @season_id).update_all(games_played: 0)
		Member.where(:team_id => @team_id, season_id: @season_id).update_all(season_minutes: 0)
	end
end


#9.92