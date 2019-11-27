
class PagesController < ApplicationController
	def index
		if user_signed_in?
			##dont use string sql
			@members = Member.find_by_sql("SELECT * FROM members WHERE user_id = #{current_user.id}")
			@teams = Array.new
			@members.each do |member|
				team = Team.find(member.team_id)
  				@teams.push team
			end

			if @teams.length == 1
				redirect_to team_path(@teams[0].id)
			end

			## StatList.delete_all
			## puts "************************ NEW ************************"
			## StatList.find_each do |stat_list|
			## 	puts stat_list.stat
			## 	puts stat_list.id
			## end
			## InsertStatListsService.new().call
			## StatList.find_each do |stat_list|
			## 	puts stat_list.stat
			## 	puts stat_list.id
			## end
			##if StatList.exists?(1)
				
			##else
				##InsertStatListsService.new().call
			##end
			##DeleteTeamService.new().call

			##ActiveRecord::Base.connection.execute("TRUNCATE play_types RESTART IDENTITY")
			##InsertPlayTypesService.new().call
			##InsertStatListsService.new().call
			##StatList.find_each do |stat_list|
			##puts stat_list.stat
			##puts stat_list.id
			##end

			#TruncateStatsService.new().call
			##InsertStatDescriptionsService.new().call
			##InsertRolesService.new().call
		end	
  end

end
