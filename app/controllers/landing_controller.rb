class LandingController < ApplicationController

	def index
  	@players = Player.where(user_id: params[:user])
  	@user_id = params[:user]
  end
end