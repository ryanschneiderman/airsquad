
class JoinTeamService
	def initialize(params)
		@roles = params[:roles]
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
			return team_to_join.id	
		else return nil
		end
	end
end