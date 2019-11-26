class PostsController < ApplicationController

	def new
		@post = Post.new()
		@team_id = params[:team_id]
	end

	def create
		@post = Post.new(
			title: params[:post][:title],
			content: params[:post][:content],
			member_id: current_user.id,
			team_id: params[:post][:team_id],
		)
		@post.save
		redirect_to team_path(params[:post][:team_id])
	end

	def show
	end

	def edit
	end

	def destroy
		post = Post.find_by_id(params[:id]).destroy
		redirect_to team_path(params[:team_id])
	end
end
