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
		@num_games = Game.where(team_id: params[:team_id], played: true).count
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
			TruncateStatsService.new(team_id: @team_id).call
		else
			rollback_team_stats
			create_advanced_team_stats
			rollback_stat_granules
			rollback_player_stats
			adjust_bpm
		end
	end

	private

	def rollback_team_stats
		@team_stats.each do |team_stat|
			team_season_stat = TeamSeasonStat.where(team_id: team_stat.team_id, stat_list_id: team_stat.stat_list_id, is_opponent: false)
			team_season_stat = team_season_stat.take
			team_season_stat.value -= team_stat.value
			team_season_stat.save
			if team_stat.stat_list_id == 16 
				puts "FOUND_TEAM_STATS"
				@team_minutes = team_season_stat.value
			end
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

	def create_advanced_team_stats
		## create team advanced stats 
		team_adv_stats = Advanced::SeasonTeamAdvancedStatsService.new({
			team_id: @team_id,
		}).call

		@defensive_efficiency = team_adv_stats["defensive_efficiency"]
		@offensive_efficiency = team_adv_stats["offensive_efficiency"]

		if(@offensive_efficiency != nil && @defensive_efficiency != nil)
			@team_rating = @offensive_efficiency - @defensive_efficiency
		end
		puts "TEAM RATING"
		puts @team_rating

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
						season_stat = SeasonStat.where(member_id: @member_id, stat_list_id: stat.stat_list_id)
						season_stat = season_stat.take
						puts "stat_list_id"
						puts stat.stat_list_id
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
					bpms = Advanced::SeasonAdvancedStatsService.new({
						member_id: @member_id,
						team_id: @team_id.to_i,
					}).call
					puts "~~minutes"
					puts @minutes
					puts "~~team_minutes"
					puts @team_minutes
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
			

			season_stat = SeasonAdvancedStat.where(stat_list_id: 42, member_id: bpm["member_id"]).take
			season_stat.value = new_bpm
			season_stat.constituent_stats = {
				"team_adjustment" => bpm_team_adjustment,
				"raw_bpm" => bpm["bpm"].value
			}
			season_stat.save

			season_stat = SeasonAdvancedStat.where(stat_list_id: 40, member_id: bpm["member_id"]).take
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



	
end
