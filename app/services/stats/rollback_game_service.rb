##
## TODO: NEED TO RECALCULATE SHOOTING STATS!!!!!
##
##
class Stats::RollbackGameService

	def initialize(params)
		@game_id = params[:game_id]
		@season_id = params[:season_id]
		@player_stats = Stat.where(game_id: @game_id, season_id: @season_id).chunk{|e| e.member_id}
		@team_stats = StatTotal.where(game_id: @game_id, is_opponent: false, season_id: @season_id)
		@lineup_stats = LineupGameStat.where(game_id: @game_id, is_opponent: false, season_id: @season_id).chunk{|e| e.lineup_id}
		@lineup_opponent_stats = LineupGameStat.where(game_id: @game_id, is_opponent: true, season_id: @season_id)
		@opponent_stats = StatTotal.where(game_id: @game_id, is_opponent: true, season_id: @season_id)
		@stat_granules = StatGranule.where(game_id: @game_id, season_id: @season_id)
		@member_id = nil
		game = Game.find_by_id(@game_id)
		@num_games = Game.where(team_id: params[:team_id], played: true, season_id: @season_id).count
		@team_id = game.team_id
		@truncate = false;
		if params[:submit] != true
			game.update(played: false)
			game.save
		else

			if @num_games == 1
				@truncate = true
			end
		end

		
		@bpm_sums = [0, 0]
		@season_bpm_sums = [0, 0]
		@all_bpms = []
		

	end

	def call
		if @truncate 
			Stats::TruncateStatsService.new(team_id: @team_id, season_id: @season_id).call
		else
			rollback_team_stats
			create_advanced_team_stats
			rollback_stat_granules
			rollback_player_stats
			adjust_bpm
			rollback_lineup_stats
			create_advanced_lineup_stats
		end
	end

	private

	def rollback_team_stats
		@team_stats.each do |team_stat|
			team_season_stat = TeamSeasonStat.where(team_id: team_stat.team_id, stat_list_id: team_stat.stat_list_id, is_opponent: false, season_id: @season_id)
			team_season_stat = team_season_stat.take
			team_season_stat.value -= team_stat.value
			team_season_stat.save
			if team_stat.stat_list_id == 16 
				@team_minutes = team_season_stat.value
			end
			team_stat.destroy
		end
		@opponent_stats.each do |opp_stat|
			opp_season_stat = TeamSeasonStat.where(team_id: opp_stat.team_id, stat_list_id: opp_stat.stat_list_id, is_opponent: true, season_id: @season_id)
			opp_season_stat = opp_season_stat.take

			opp_season_stat.value -= opp_stat.value
			opp_season_stat.save
			opp_stat.destroy
		end
	end

	def rollback_lineup_stats
		@lineup_stats.each do |l_stat_arr|
			l_stat_arr.each do |l_stat|
				puts "l_stat"
				puts l_stat
				if l_stat.is_a? Integer
					@lineup_id = l_stat
					@lineup = Lineup.find_by_id(@lineup_id)
					## TODO add games played to lineup
					#@lineup.games_played -=1
				else
					l_stat.each do |stat|
						season_stat = LineupStat.where(lineup_id: @lineup_id, stat_list_id: stat.stat_list_id, season_id: @season_id)
						season_stat = season_stat.take
						if stat.stat_list_id == 16 
							@lineup.season_minutes -= stat.value
							@lineup.save
							puts @lineup.season_minutes
							@minutes = @lineup.season_minutes
						end
						season_stat.value -= stat.value
						season_stat.save
						stat.destroy
					end

					Stats::Lineups::CalcLineupAdvancedStatsService.new({
						lineup_id: @lineup_id,
						team_id: @team_id,
					}).call
				end
				
			end
		end
	end

	def create_advanced_team_stats
		## create team advanced stats 
		team_adv_stats = Stats::Advanced::Team::SeasonTeamAdvancedStatsService.new({
			team_id: @team_id,
			season_id: @season_id
		}).call

		@defensive_efficiency = team_adv_stats["defensive_efficiency"]
		@offensive_efficiency = team_adv_stats["offensive_efficiency"]

		if(@offensive_efficiency != nil && @defensive_efficiency != nil)
			@team_rating = @offensive_efficiency - @defensive_efficiency
		end

	end

	def rollback_player_stats
		@player_stats.each do |p_stat_arr|
			p_stat_arr.each do |p_stat|
				puts "p_stat"
				puts p_stat
				if p_stat.is_a? Integer
					@member_id = p_stat
					@member = Member.find_by_id(@member_id)
					@member.games_played -=1
				else
					p_stat.each do |stat|
						season_stat = SeasonStat.where(member_id: @member_id, stat_list_id: stat.stat_list_id, season_id: @season_id)
						season_stat = season_stat.take
						if stat.stat_list_id == 16 
							@member.season_minutes -= stat.value
							@member.save
							puts @member.season_minutes
							@minutes = @member.season_minutes
						end
						season_stat.value -= stat.value
						season_stat.save
						stat.destroy
					end
					bpms = Stats::Advanced::Player::SeasonAdvancedStatsService.new({
						member_id: @member_id,
						team_id: @team_id.to_i,
						season_id: @season_id
					}).call
					if(bpms["obpm"] && bpms["obpm"].value != nil)
						@bpm_sums[0] += bpms["obpm"].value * (@minutes / (@team_minutes / 5))
						#puts "adding_bpm"
						#puts bpms["bpm"].value * (@minutes / (@team_minutes / 5))
						@bpm_sums[1] += bpms["bpm"].value * (@minutes / (@team_minutes / 5))

						#@season_bpm_sums[0] += bpms["new_obpm"].value * (@season_minutes / (@season_team_minutes / 5))
						#@season_bpm_sums[1] += bpms["new_bpm"].value * (@season_minutes / (@season_team_minutes / 5))
						@all_bpms.push(bpms)
					end
				end
				
			end
		end
	end

	## TODO: MOVE TO DIFFERENT SERVICE -- come back to later
	def adjust_bpm
		@all_bpms.each do |bpm|
			bpm_team_adjustment = (@team_rating * 1.2 - @bpm_sums[1])/5
			new_bpm = bpm["bpm"].value + bpm_team_adjustment
			new_bpm = new_bpm * 100 
			new_bpm = new_bpm.round / 100.0


			obpm_team_adjustment = (@team_rating * 1.2 - @bpm_sums[1])/5
			new_obpm = bpm["obpm"].value + obpm_team_adjustment
			new_obpm = new_obpm * 100
			new_obpm = new_obpm.round / 100.0
			

			season_stat = SeasonAdvancedStat.where(stat_list_id: 42, member_id: bpm["member_id"], season_id: @season_id).take
			season_stat.value = new_bpm
			season_stat.constituent_stats = {
				"team_adjustment" => bpm_team_adjustment,
				"raw_bpm" => bpm["bpm"].value
			}
			season_stat.save

			season_stat = SeasonAdvancedStat.where(stat_list_id: 40, member_id: bpm["member_id"], season_id: @season_id).take
			season_stat.value = new_obpm
			season_stat.constituent_stats = {
				"team_adjustment" => obpm_team_adjustment,
				"raw_bpm" => bpm["obpm"].value
			}
			season_stat.save
		end
	end



	def rollback_stat_granules
		@stat_granules.each do |stat_granule|
			stat_granule.destroy
		end
	end

	

	def create_lineup_advanced_stats
	end



	
end
