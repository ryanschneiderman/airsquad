class Teams::UpdateMembersService
	def initialize(params)
		@members = params[:members]
		@team_id = params[:team_id]
	end

	def call
		(@members || []).each do |new_member|
			json = get_permissions_json(new_member[1])
			new_member = new_member[1]

			member = Member.find_by_id(new_member[:id])
			member.update({
				nickname: new_member[:name],
				permissions: json,
				email: new_member[:email],
				is_player: new_member[:is_player],
			})
			update_member_role(member, new_member[:role_name])

		end
	end

	private 

	def update_member_role(member, member_role)
		assignment = Assignment.find_by(member_id: member.id)
		case member_role
		when "Player"
			assignment.update({
				role_id: 1
			})
		when "Coach"
			assignment.update({
				role_id: 2
			})
		when "Manager"
			assignment.update({
				role_id: 3
			})
		when "Other"
			assignment.update({
				role_id: 5
			})
		end
	end

	def get_permissions_json(member)
		case member[:role_name]
		when "Player"
			return get_player_permissions
		when "Coach"
			return get_coach_permissions
		when "Manager"
			return get_manager_permissions
		when "Other"
			return get_other_permissions(member)
		end
	end

	def get_player_permissions
		{"plays_view" => true, "plays_edit" => false, "schedule_view" => true, "schedule_edit" => false, "stats_view" => true, "stats_edit" => false, "settings_view" => true, "settings_edit" => false }
	end

	def get_coach_permissions
		{"plays_view" => true, "plays_edit" => true, "schedule_view" => true, "schedule_edit" => true, "stats_view" => true, "stats_edit" => true, "settings_view" => true, "settings_edit" => true }
	end

	def get_manager_permissions
		{"plays_view" => true, "plays_edit" => false, "schedule_view" => true, "schedule_edit" => false, "stats_view" => true, "stats_edit" => false, "settings_view" => true, "settings_edit" => false }
	end

	def get_other_permissions(member)
		{"plays_view" => member[:permissions][:plays_view], "plays_edit" => member[:permissions][:plays_edit], "schedule_view" => member[:permissions][:schedule_view], "schedule_edit" => member[:permissions][:schedule_edit], "stats_view" => member[:permissions][:stats_view], "stats_edit" => member[:permissions][:stats_edit], "settings_view" => member[:permissions][:settings_view], "settings_edit" => member[:permissions][:settings_edit] }
	end
end





