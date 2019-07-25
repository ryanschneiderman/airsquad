class StatListsController < ApplicationController
	def index
	end 
	
	def new
		@stat_list = StatList.new()
	end

	def create
		granular = params[:stat_list][:granular]
		advanced = params[:stat_list][:advanced]
		default = params[:stat_list][:default]
		collectable = params[:stat_list][:collectable]
		team_stat = params[:stat_list][:team_stat]

		puts granular

		@stat_list = StatList.new(
			stat: params[:stat_list][:stat],
			advanced: advanced,
			default: default,
			collectable: collectable,
			team_stat: team_stat
		)
		@stat_list.save
		redirect_to stat_lists_path
	end

	def show
	end
end
