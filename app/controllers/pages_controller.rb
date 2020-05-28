
class PagesController < ApplicationController
	skip_before_action :authenticate_user!, only: [:index, :about, :tutorial, :test_home, :product, :demo1, :play_demo]
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
		end	
  end

  def about
  end

  def tutorial
  end

  def product
  end

  def test_home
  end

  def demos
  end

  def demo1
  end

  def play_demo
  end

end
