class Stats::LineupStatRankingService
	def initialize(params)
		@team_id = params[:team_id]
		@is_lineup = params[:is_lineup]
	end

	def call
		all_rankings = []
		all_rankings_index = 0
		adv_rankings = []
		adv_rankings_index = 0

		stats = LineupStat.joins(:stat_list, :lineup).select(" stat_lists.stat as stat, stat_lists.is_percent as is_percent, stat_lists.advanced as advanced, lineups.team_id as team_id, lineup_stats.*, lineups.id as lineup_id, lineups.season_minutes as season_minutes").where('lineups.team_id' => @team_id, 'stat_lists.rankable'=> true, 'lineup_stats.is_opponent' => false).sort_by{|e| [e.stat_list_id]}
		adv_stats = LineupAdvStat.joins(:stat_list, :lineup).select("stat_lists.stat as stat, stat_lists.advanced as advanced, lineups.team_id as team_id, lineup_adv_stats.*, lineups.id as lineup_id").where('lineups.team_id' => @team_id, 'lineup_adv_stats.is_opponent' => false).sort_by{|e| [e.stat_list_id]}

		curr_stat_list = stats[0].stat_list_id
		all_rankings.append([])

		## iterating over each stat
		stats.each do |stat|
			## check if current stat_list is different than previous
			if stat.stat_list_id != curr_stat_list
				## if true, create new array to hold all stats with new stat_lsit
				new_array = []
				curr_stat_list = stat.stat_list_id
				new_array.append(stat)
				all_rankings.append(new_array)
				all_rankings_index +=1
			else
				all_rankings[all_rankings_index].append(stat)
			end
		end

		curr_stat_list = adv_stats[0].stat_list_id
		adv_rankings.append([])

		if adv_stats
		   curr_stat_list = adv_stats[0].stat_list_id
		   adv_stats.each do |adv_stat|
				if adv_stat.stat_list_id != curr_stat_list
					new_array = []
					curr_stat_list = adv_stat.stat_list_id
					new_array.append(adv_stat)
					adv_rankings.append(new_array)
					adv_rankings_index +=1
				else
					adv_rankings[adv_rankings_index].append(adv_stat)
				end
			end
		end	

		all_rankings.each do |ranking|
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
					per_minute_ranks = ranking.sort{|a, b| (b.value/b.season_minutes.to_f) <=> (a.value/a.season_minutes.to_f)}
				end
				per_minute_rank = 0
				per_minute_ranks.each do |stat|
					stat.update_attribute(:rank, per_minute_rank)
					per_minute_rank +=1
				end
			end
		end

		adv_rankings.each do |ranking|
			if(ranking[0].stat_list_id == 25 or ranking[0].stat_list_id == 38 or ranking[0].stat_list_id == 31)
				percent_ranks = ranking.sort{|a, b| (a.value <=> b.value)}
			else	
				percent_ranks = ranking.sort{|a, b| (b.value <=> a.value)}
			end
			percent_rank = 0 
			percent_ranks.each do |stat|
				stat.update_attribute(:rank, percent_rank)
				percent_rank +=1
			end
		end
	end
end

