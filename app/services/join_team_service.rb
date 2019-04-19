class JoinTeamService
	def initialize(params)
		@member_type = params[:member_type]
		@team_username = params[:team_username]
		@team_password = params[:team_password]
		@current_user = params[:current_user]
		@root_path = params[:root_path]
	end

	def call
		team_relation = Team.where(username: @team_username)
		password_relation = team_relation.pluck(:password)
		password_to_check = password_relation[0]
		team_to_join = team_relation.take

		## define admin priveleges based on nature of invitation?? have admin dictate who can and cannot have admin priveleges 
		## admin-coach status?
		## case other .... e.g. manager (non player, non admin, non creator, but still part of team)
		if password_to_check == @team_password
			case @member_type
			when "player"
				new_member = Member.new(
					nickname: @current_user.name,
					user_id: @current_user.id,
					team_id: team_to_join.id,
					isPlayer: true
					)
				new_member.save
				##eventually redirect to team page
			when "coach"
				new_member = Member.new(
					nickname: @current_user.name,
					team_id: team_to_join.id,
					user_id: @current_user.id,
					isAdmin: true
					)
				new_member.save

				##eventually redirect to team page
			end	
		end		
	end
end