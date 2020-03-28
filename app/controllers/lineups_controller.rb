class LineupsController < ApplicationController	
	def index
		@team_id = params[:team_id]

		@curr_member =  Assignment.joins(:role).joins(:member).select("roles.name as role_name, members.*").where("members.user_id" => current_user.id, "members.team_id" => params[:team_id])
		@is_admin = false
		@curr_member.each do |member_obj|
			if member_obj.role_name == "Admin"
				@is_admin = true
			end
		end

		minutes_p_q = Team.find_by_id(@team_id).minutes_p_q
		@minutes_factor = minutes_p_q * 4

		@lineup_stats_off = LineupStat.joins(:stat_list, :lineup).select("stat_lists.stat as stat, stat_lists.rankable as rankable, stat_lists.stat_kind as stat_kind, stat_lists.display_priority as display_priority, lineup_stats.*, lineups.team_id as team_id, lineups.id as lineup_id").where("lineups.team_id" => @team_id, "lineup_stats.is_opponent" => false, "stat_lists.stat_kind" => 1, "stat_lists.rankable" => true).sort_by{|e| [e.lineup_id, e.stat_list_id]}
		@lineup_stats_def = LineupStat.joins(:stat_list, :lineup).select("stat_lists.stat as stat, stat_lists.rankable as rankable, stat_lists.stat_kind as stat_kind, stat_lists.display_priority as display_priority, lineup_stats.*, lineups.team_id as team_id, lineups.id as lineup_id").where("lineups.team_id" => @team_id, "lineup_stats.is_opponent" => false, "stat_lists.stat_kind" => 2, "stat_lists.rankable" => true).sort_by{|e| [e.lineup_id, e.stat_list_id]}
		@lineup_stats = LineupStat.joins(:stat_list, :lineup).select("stat_lists.stat as stat, stat_lists.stat_kind as stat_kind, stat_lists.display_priority as display_priority, lineup_stats.*, lineups.team_id as team_id, lineups.id as lineup_id").where("lineups.team_id" => @team_id, "lineup_stats.is_opponent" => false,).sort_by{|e| [e.lineup_id, e.stat_list_id]}	
		@lineup_opponent_stats = LineupStat.joins(:stat_list, :lineup).select("stat_lists.stat as stat, stat_lists.display_priority as display_priority, lineup_stats.*, lineups.team_id as team_id, lineups.id as lineup_id").where("lineups.team_id" => @team_id, "lineup_stats.is_opponent" => true).sort_by{|e| [e.lineup_id, e.stat_list_id]}
		@lineup_adv_stats = LineupAdvStat.joins(:stat_list, :lineup).select("stat_lists.stat as stat, stat_lists.display_priority as display_priority, lineup_adv_stats.*, lineups.team_id as team_id, lineups.id as lineup_id").where("lineups.team_id" => @team_id).sort_by{|e| [e.lineup_id, e.stat_list_id]}
		@lineup_objs = []
		@lineup_stats.group_by(&:lineup_id).each do |lineups|
			lineup_members = LineupsMember.joins(:member).select("members.nickname as name, lineups_members.*").where("lineups_members.lineup_id" => lineups[1][0].lineup_id)
			lineup_members.each do |mem|
				puts mem
			end
			@lineup_objs.push({:lineup_stats => lineups[1], :lineup_members => lineup_members, :opponent_stats => nil, :advanced_stats => nil, :off_stats => nil, :def_stats => nil})
		end
		counter = 0
		@lineup_opponent_stats.group_by(&:lineup_id).each do |lineups|
			@lineup_objs[counter][:opponent_stats] = lineups[1]
			counter+= 1
		end
		counter = 0
		@lineup_adv_stats.group_by(&:lineup_id).each do |lineups|
			@lineup_objs[counter][:advanced_stats] = lineups[1]
			counter+=1
		end
		counter = 0
		@lineup_stats_off.group_by(&:lineup_id).each do |lineups|
			@lineup_objs[counter][:off_stats] = lineups[1]
			counter+=1
		end
		counter = 0
		@lineup_stats_def.group_by(&:lineup_id).each do |lineups|
			@lineup_objs[counter][:def_stats] = lineups[1]
			counter+=1
		end

		## stat table columns
		@stat_table_columns = Stats::BasicStatService.new({
			team_id: params[:team_id]
		}).call

		@stat_table_columns = @stat_table_columns.sort_by{|e| [e[:stat_kind], e[:display_priority]]}

		@lineups = Lineup.where(team_id: @team_id)
		
		@members = Assignment.joins(:role).joins(:member).select("roles.name as name, members.*").where("members.team_id" => @team_id, "roles.id" => 1)
	end
end