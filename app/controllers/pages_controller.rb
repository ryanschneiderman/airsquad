
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
		end	

		@image = Dir.glob("app/assets/images/Jordan/Sprite-Grid.png")
  end

end
