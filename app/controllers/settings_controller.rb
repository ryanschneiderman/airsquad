class SettingsController < ApplicationController
	def index
		@curr_member =  Assignment.joins(:role).joins(:member).select("roles.name as role_name, members.*").where("members.user_id" => current_user.id, "members.team_id" => params[:team_id]).take
		@settings_permission = false
		if(@curr_member.permissions["settings_edit"])
			@settings_permission = true
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
		non_default_advanced = StatList.where(advanced: true, team_stat: false, default_stat: false, hidden: false)
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
			puts stat.stat
			add_stat = @non_default_team_advanced_belongs.none?{|s| s.stat_list_id == stat.id}
			if add_stat
				@non_default_team_advanced_add.push(stat)
			end
		end


		@default_collectable = StatList.where(default_stat: true, collectable: true)
		@default_basic = StatList.where(default_stat: true, rankable: true, advanced: false).sort_by{|stat| stat.id}
		@default_application_basic = StatList.where(default_stat: true, collectable: false, advanced: false)
		@default_indiv_advanced = StatList.where(default_stat: true, advanced: true)
		@default_team_advanced = StatList.where(default_stat: true, advanced: true, team_stat: true)
		@non_default_indiv_advanced = StatList.where(advanced: true, team_stat: false, default_stat: false, hidden: false)
		@non_default_team_advanced = StatList.where(advanced: true, team_stat: true, default_stat: false, hidden: false)

		@advanced_stats = AdvStatDependenciesService.new({adv_stats: @non_default_indiv_advanced}).call

		@team_advanced_stats = TeamAdvStatDependenciesService.new({adv_stats: @non_default_team_advanced}).call


		gon.default_collectable = @default_collectable
		gon.default_application_basic = @default_application_basic
		gon.default_indiv_advanced = @default_indiv_advanced
		gon.advanced_stats = @advanced_stats
		gon.team_advanced_stats = @team_advanced_stats
		gon.non_default_collectable_belongs = @non_default_collectable_belongs


		######## MEMBERS ########
		@team = Team.find_by_id(@team_id)
		gon.team = @team

		members = Assignment.joins(:role).joins(:member).select("roles.id as role_id, roles.name as role_name, members.*, members.nickname as name").where("members.team_id" => @team_id)

		gon.members = members
	end

	def update
		stats_to_add = params[:stats_to_add]
		stats_to_remove = params[:stats_to_remove]

		new_members = params[:new_members]
		remove_members = params[:remove_members]
		update_members = params[:update_members]

		team_id = params[:team_id]
		team = Team.find_by_id(team_id)
		team.update(name: params[:team_name], num_periods: params[:period_type], period_length: params[:period_length], primary_color: params[:primary_color], secondary_color: params[:secondary_color])
		
		Teams::CreateTeamMembersService.new({
			members: new_members,
			team_id: team_id
		}).call

		Teams::UpdateMembersService.new({
			members: params[:update_members],
			team_id: team_id
		}).call
		
		(remove_members || []).each do |member|
			assignment = Assignment.where(member_id: member[1][:id]).take
			assignment.destroy()
		end


		Teams::TeamStatService.new({
			team_stats: stats_to_add,
			team_id: team_id
		}).call

		(stats_to_remove || []).each do |stat_id|
			puts "STAT ID"
			puts stat_id
			team_stat = TeamStat.where(stat_list_id: stat_id, team_id: team_id).take
			if team_stat 
				TeamStat.destroy(team_stat.id)
			end
		end

		redirect_to team_settings_path(team_id)
	end
end
