class SettingsController < ApplicationController
	def index
		@curr_member =  Assignment.joins(:role).joins(:member).select("roles.name as role_name, members.*").where("members.user_id" => current_user.id, "members.team_id" => params[:team_id])
		@settings_permission = false
		@curr_member.each do |member_obj|
			if member_obj.role_name == "Admin" || member_obj.role_name == "Manager"
				@settings_permission = true
			end
		end
		@team_id = params[:team_id]

		## all non_default collectable stats that don't belong to a team,, default_stat: false, collectable: true
		@non_default_collectable_belongs = TeamStat.joins(:stat_list).select("stat_lists.*, team_stats.*").where("stat_lists.default_stat" => false, "stat_lists.collectable" => true, "team_stats.team_id" => @team_id).sort_by{|e| e.stat_list_id}
		non_default_collectable =  StatList.where(default_stat: false, collectable: true)
		@non_default_collectable_add = []
		non_default_collectable.each do |stat| 
			add_stat = @non_default_collectable_belongs.none?{|s| s.stat_list_id == stat.id}
			if add_stat 
				@non_default_collectable_add.push(stat)
			end
		end

		@non_default_advanced_belongs = TeamStat.joins(:stat_list).select("stat_lists.*, team_stats.*").where("stat_lists.default_stat" => false, "stat_lists.advanced" => true, "stat_lists.team_stat" => false, "team_stats.team_id" => @team_id).sort_by{|e| e.stat_list_id}
		non_default_advanced = StatList.where(advanced: true, team_stat: false, default_stat: false)
		@non_default_advanced_add = []
		non_default_advanced.each do |stat|
			add_stat = @non_default_advanced_belongs.none?{|s| s.stat_list_id == stat.id}
			if add_stat
				@non_default_advanced_add.push(stat)
			end
		end

		@non_default_team_advanced_belongs = TeamStat.joins(:stat_list).select("stat_lists.*, team_stats.*").where("stat_lists.default_stat" => false, "stat_lists.advanced" => true, "stat_lists.team_stat" => true, "team_stats.team_id" => @team_id).sort_by{|e| e.stat_list_id}
		
		non_default_team_advanced = StatList.where(advanced: true, team_stat: true, default_stat: false)
		@non_default_team_advanced_add = []
		non_default_team_advanced.each do |stat|
			add_stat = @non_default_team_advanced_belongs.any?{|s| s.id == stat.id}
			if add_stat
				@non_default_team_advanced_add.push(add_stat)
			end
		end

		@default_collectable = StatList.where(default_stat: true, collectable: true)
		@default_basic = StatList.where(default_stat: true, rankable: true, advanced: false).sort_by{|stat| stat.id}
		@default_application_basic = StatList.where(default_stat: true, collectable: false, advanced: false)
		@default_indiv_advanced = StatList.where(default_stat: true, advanced: true)
		@default_team_advanced = StatList.where(default_stat: true, advanced: true, team_stat: true)
		@non_default_indiv_advanced = StatList.where(advanced: true, team_stat: false, default_stat: false)
		@non_default_team_advanced = StatList.where(advanced: true, team_stat: true, default_stat: false)

		@advanced_stats = AdvStatDependenciesService.new({adv_stats: @non_default_indiv_advanced}).call

		@team_advanced_stats = TeamAdvStatDependenciesService.new({adv_stats: @non_default_team_advanced}).call


		######## MEMBERS ########
		@team = Team.find_by_id(@team_id)

		@players = Assignment.joins(:role).joins(:member).select("roles.name as name, members.*").where("members.team_id" => @team_id, "roles.id" => 1)

	end

	def update
		stats_to_add = params[:stats_to_add]
		stats_to_remove = params[:stats_to_remove]
		new_players = params[:new_players]
		remove_players = params[:remove_players]
		team_id = params[:team_id]
		team = Team.find_by_id(team_id)
		team.update(name: params[:team_name], minutes_p_q: params[:minutes_p_q], username: params[:username], password: params[:password])
		if new_players
			new_players.each do |player|
				member = Member.create({
					nickname: player,
					team_id: team.id,
					season_minutes: 0,
					games_played: 0,
				})
				Assignment.create({
					member_id: member.id,
					role_id: 1
				})
			end
		end
		if remove_players
			remove_players.each do |player|
				assignment = Assignment.where(member_id: player).take
				assignment.destroy()
			end
		end
		if stats_to_add
			stats_to_add.each do |stat_id|
				team_stat = TeamStat.create(
					stat_list_id: stat_id,
					team_id: team_id,
					show: true,
				)
			end
		end
		if stats_to_remove
			stats_to_remove.each do |stat_id|
				team_stat = TeamStat.where(stat_list_id: stat_id, team_id: team_id)
				puts team_stat
				if team_stat 
					TeamStat.destroy(team_stat.take.id)
				end
			end
		end
		redirect_to team_settings_path(team_id)
	end
end
