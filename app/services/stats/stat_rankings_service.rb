class Stats::StatRankingsService
	def initialize(params)
		@team_id = params[:team_id]
		@is_lineup = params[:is_lineup]
	end

	def call
		all_rankings = []
		all_rankings_index = 0
		if !@is_lineup
			stats = SeasonStat.joins(:stat_list, :member).select("members.games_played as games_played, members.season_minutes as season_minutes, stat_lists.is_percent as is_percent, stat_lists.advanced as advanced, season_stats.*").where('members.team_id' => @team_id, 'stat_lists.rankable'=> true).sort_by{|e| [e.stat_list_id]}
			adv_stats = SeasonAdvancedStat.joins(:stat_list, :member).select("stat_lists.is_percent as is_percent, stat_lists.advanced as advanced, season_advanced_stats.*").where('members.team_id' => @team_id, 'stat_lists.rankable'=> true).sort_by{|e| [e.stat_list_id]}
		else
			stats = LineupStat.joins(:stat_list, :lineup).select(" stat_lists.stat as stat, stat_lists.is_percent as is_percent, stat_lists.advanced as advanced, lineups.team_id as team_id, lineup_stats.*, lineups.id as lineup_id, lineups.season_minutes as season_minutes").where('lineups.team_id' => @team_id, 'stat_lists.rankable'=> true).sort_by{|e| [e.stat_list_id]}
			##adv_stats = LineupAdvStat.joins(:stat_list, :lineup).select("stat_lists.stat as stat, stat_lists.is_percent as is_percent, stat_lists.advanced as advanced, lineups.team_id as team_id, lineups.id as lineup_id, lineup_adv_stats.*").where('lineups.team_id' => @team_id, 'stat_lists.rankable'=> true).sort_by{|e| [e.stat_list_id]}
		end

		curr_stat_list = stats[0].stat_list_id
		all_rankings.append([])

		stats.each do |stat|
			if stat.stat_list_id != curr_stat_list
				new_array = []
				curr_stat_list = stat.stat_list_id
				new_array.append(stat)
				all_rankings.append(new_array)
				all_rankings_index +=1
			else
				all_rankings[all_rankings_index].append(stat)
			end
		end
		all_rankings.append([])
		all_rankings_index+=1

		if adv_stats
		   curr_stat_list = adv_stats[0].stat_list_id
		   adv_stats.each do |adv_stat|
				if adv_stat.stat_list_id != curr_stat_list
					new_array = []
					curr_stat_list = adv_stat.stat_list_id
					new_array.append(adv_stat)
					all_rankings.append(new_array)
					all_rankings_index +=1
				else
					all_rankings[all_rankings_index].append(adv_stat)
				end
			end
		end
		

		all_rankings.each do |ranking|
			if @is_lineup 
				if ranking[0].is_percent
					if(ranking[0].stat_list_id == 25 or ranking[0].stat_list_id == 38)
						percent_ranks = ranking.sort{|a, b| (a.value <=> b.value)}
					else	
						percent_ranks = ranking.sort{|a, b| (b.value <=> a.value)}
					end
					percent_rank = 0 
					if percent_ranks[0].advanced
						percent_ranks.each do |stat|
							stat.update_attribute(:rank, percent_rank)
							percent_rank +=1
						end
					else
						percent_ranks.each do |stat|
							stat.update_attribute(:rank, percent_rank)
							percent_rank +=1
						end
					end
				else
					if(ranking[0].stat_list_id == 7 || ranking[0].stat_list_id == 17)
						per_minute_ranks = ranking.sort{|a, b| (a.value/a.season_minutes.to_f) <=> (b.value/b.season_minutes.to_f)}
					else
						puts "ranking season_minutes"
						puts ranking[0].season_minutes
						puts ranking[1].season_minutes	
						per_minute_ranks = ranking.sort{|a, b| (b.value/b.season_minutes.to_f) <=> (a.value/a.season_minutes.to_f)}
					end
					per_minute_rank = 0
					per_minute_ranks.each do |stat|
						stat.update_attribute(:rank, per_minute_rank)
						per_minute_rank +=1
					end
				end
			else 	
				if ranking[0].is_percent
					if(ranking[0].stat_list_id == 25 or ranking[0].stat_list_id == 38)
						percent_ranks = ranking.sort{|a, b| (a.value <=> b.value)}
					else	
						percent_ranks = ranking.sort{|a, b| (b.value <=> a.value)}
					end
					percent_rank = 0 
					if percent_ranks[0].advanced
						percent_ranks.each do |stat|
							stat.update_attribute(:team_rank, percent_rank)
							percent_rank +=1
						end
					else
						percent_ranks.each do |stat|
							stat.update_attribute(:per_game_rank, percent_rank)
							stat.update_attribute(:per_minute_rank, percent_rank)
							percent_rank +=1
						end
					end
				else
					if(ranking[0].stat_list_id == 7 || ranking[0].stat_list_id == 17)
						per_game_ranks = ranking.sort{|a, b| (a.value/a.games_played.to_f) <=> (b.value/b.games_played.to_f)}
						per_minute_ranks = ranking.sort{|a, b| (a.value/a.season_minutes.to_f) <=> (b.value/b.season_minutes.to_f)}
					else	
						per_game_ranks = ranking.sort{|a, b| (b.value/b.games_played.to_f) <=> (a.value/a.games_played.to_f)}
						per_minute_ranks = ranking.sort{|a, b| (b.value/b.season_minutes.to_f) <=> (a.value/a.season_minutes.to_f)}
					end
					per_game_rank = 0
					per_game_ranks.each do |stat|
						stat.update_attribute(:per_game_rank, per_game_rank)
						per_game_rank +=1
					end
					per_minute_rank = 0
					per_minute_ranks.each do |stat|
						stat.update_attribute(:per_minute_rank, per_minute_rank)
						per_minute_rank +=1
					end
				end
			end
		end
	end
end

