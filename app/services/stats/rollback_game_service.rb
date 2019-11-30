##
## TODO: NEED TO RECALCULATE SHOOTING STATS!!!!!
##
##
class Stats::RollbackGameService

	def initialize(params)
		@game_id = params[:game_id]
		@player_stats = Stat.where(game_id: @game_id).chunk{|e| e.member_id}
		@team_stats = StatTotal.where(game_id: @game_id, is_opponent: false)
		@opponent_stats = StatTotal.where(game_id: @game_id, is_opponent: true)
		@stat_granules = StatGranule.where(game_id: @game_id)
		@member_id = nil
		game = Game.find_by_id(@game_id)
		game.played = false
		game.save
		@team_id = game.team_id
	end

	def call
		rollback_team_stats
		create_advanced_team_stats
		rollback_stat_granules
		rollback_player_stats
	end

	private

	def rollback_team_stats
		@team_stats.each do |team_stat|
			team_season_stat = TeamSeasonStat.where(team_id: team_stat.team_id, stat_list_id: team_stat.stat_list_id, is_opponent: false)
			team_season_stat = team_season_stat.take

			team_season_stat.value -= team_stat.value
			team_season_stat.save
			team_stat.destroy
		end
		@opponent_stats.each do |opp_stat|
			opp_season_stat = TeamSeasonStat.where(team_id: opp_stat.team_id, stat_list_id: opp_stat.stat_list_id, is_opponent: true)
			opp_season_stat = opp_season_stat.take

			opp_season_stat.value -= opp_stat.value
			opp_season_stat.save
			opp_stat.destroy
		end
	end

	def create_advanced_team_stats()
		## create team advanced stats 
		team_adv_stats = Advanced::SeasonTeamAdvancedStatsService.new({
			team_id: @team_id,
		}).call
=begin
		@possessions = team_adv_stats["possessions"]
		@opp_possessions = team_adv_stats["opp_possessions"]

		@defensive_efficiency = team_adv_stats["defensive_efficiency"]
		@offensive_efficiency = team_adv_stats["offensive_efficiency"]

		@season_offensive_efficiency = team_adv_stats["season_offensive_efficiency"]
		@season_defensive_efficiency = team_adv_stats["season_defensive_efficiency"]

		if(@offensive_efficiency != nil && @defensive_efficiency != nil)
			@season_team_rating = @season_offensive_efficiency - @season_defensive_efficiency
			@team_rating = @offensive_efficiency - @defensive_efficiency
		end
=end
	end

	def rollback_player_stats
		@player_stats.each do |p_stat_arr|
			p_stat_arr.each do |p_stat|
				if p_stat.is_a? Integer
					@member_id = p_stat
					@member = Member.find_by_id(@member_id)
					@member.games_played -=1
				else
					p_stat.each do |stat|
						season_stat = SeasonStat.where(member_id: @member_id, stat_list_id: stat.stat_list_id)
						season_stat = season_stat.take
						if stat.stat_list_id == 16 
							@member.season_minutes -= stat.value
							@member.save
						end
						season_stat.value -= stat.value
						season_stat.save
						stat.destroy
						instantiate_stat_variable(season_stat, false, false, false)
					end
				end
				bpms = Advanced::SeasonAdvancedStatsService.new({
					member_id: @member_id,
					team_id: @team_id.to_i,
				}).call
			end
		end
	end



	def rollback_stat_granules
		@stat_granules.each do |stat_granule|
			stat_granule.destroy
		end
	end



	
end
