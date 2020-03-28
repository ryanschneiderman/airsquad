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

		@lineup_stats = LineupStat.joins(:stat_list, :lineup).select("stat_lists.stat as stat, lineup_stats.*, lineups.team_id as team_id, lineups.id as lineup_id").where("lineups.team_id" => @team_id).sort_by{|e| [e.lineup_id, e.stat_list_id]}
		
		## need season stats for each player
		@def_season_stats = SeasonStat.joins(:stat_list, :member).select("members.games_played as games_played, members.season_minutes as season_minutes, stat_lists.stat as stat, stat_lists.stat_kind as stat_kind, members.nickname as nickname, stat_lists.display_priority as display_priority, stat_lists.is_percent as is_percent, season_stats.*").where('members.team_id' => @team_id, 'stat_lists.stat_kind' => 2).sort_by{|e| [e.member_id, e.stat_list_id]}
		@off_season_stats = SeasonStat.joins(:stat_list, :member).select("members.games_played as games_played, members.season_minutes as season_minutes, stat_lists.stat as stat, stat_lists.stat_kind as stat_kind, members.nickname as nickname, stat_lists.display_priority as display_priority, stat_lists.is_percent as is_percent, season_stats.*").where('members.team_id' => @team_id, 'stat_lists.stat_kind' => 1).sort_by{|e| [e.member_id, e.stat_list_id]}
		@shooting_stats = SeasonStat.joins(:stat_list, :member).select("members.games_played as games_played, members.season_minutes as season_minutes, stat_lists.stat as stat, stat_lists.stat_kind as stat_kind, members.nickname as nickname, stat_lists.display_priority as display_priority, stat_lists.is_percent as is_percent, season_stats.*").where('members.team_id' => @team_id, 'season_stats.stat_list_id' => [1,2, 11, 12, 13,14,15]).sort_by{|e| [e.member_id, e.stat_list_id]}
		## need advanced stats for each player
		@off_advanced_stats = SeasonAdvancedStat.joins(:stat_list, :member).select("stat_lists.stat as stat, members.nickname as nickname, stat_lists.stat_kind as stat_kind, stat_lists.display_priority as display_priority, season_advanced_stats.*").where('members.team_id' => @team_id, 'stat_lists.stat_kind' => 1).sort_by{|e| [e.member_id, e.stat_list_id]}
		@def_advanced_stats = SeasonAdvancedStat.joins(:stat_list, :member).select("stat_lists.stat as stat, members.nickname as nickname, stat_lists.stat_kind as stat_kind, stat_lists.display_priority as display_priority, season_advanced_stats.*").where('members.team_id' => @team_id, 'stat_lists.stat_kind' => 2).sort_by{|e| [e.member_id, e.stat_list_id]}
		@neut_advanced_stats = SeasonAdvancedStat.joins(:stat_list, :member).select("stat_lists.stat as stat, members.nickname as nickname, stat_lists.stat_kind as stat_kind, stat_lists.display_priority as display_priority, season_advanced_stats.*").where('members.team_id' => @team_id, 'stat_lists.stat_kind' => 3).sort_by{|e| [e.member_id, e.stat_list_id]}
		
		## stat table columns
		@stat_table_columns = Stats::BasicStatService.new({
			team_id: params[:team_id]
		}).call

		@stat_table_columns = @stat_table_columns.sort_by{|e| [e[:stat_kind], e[:stat_list_id]]}

		@adv_stat_table_columns = Stats::AdvancedStatListService.new({
			team_id: params[:team_id]
		}).call

		@lineups = Lineup.where(team_id: @team_id)
		
		@members = Assignment.joins(:role).joins(:member).select("roles.name as name, members.*").where("members.team_id" => @team_id, "roles.id" => 1)
	end

	def create
		members = params[:members]
		lineup_name = params[:name]
		lineup = Lineup.create(
			team_id: params[:team_id],
			name: lineup_name
		)

		members.each do |member_id|
			member = Member.find_by_id(member_id)
			lineup.members << member
		end

		redirect_to team_lineups_path(params[:team_id])
	end

	def update
		lineup_id = params[:id]
		new_members = params[:members]
		lineup_name = params[:name]
		lineup = Lineup.find_by_id(lineup_id)
		lineup.update(name: lineup_name)
		lineup.members.clear
		
		new_members.each do |member_id|
			member = Member.find_by_id(member_id)
			lineup.members << member
		end
		lineup.save
		redirect_to team_lineups_path(params[:team_id])
	end

	def destroy
		lineup_id = params[:id]
		lineup = Lineup.find_by_id(lineup_id)
		lineup.members.clear
		lineup.destroy
		redirect_to team_lineups_path(params[:team_id])
	end

end