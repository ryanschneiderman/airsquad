class PostsController < ApplicationController
respond_to :html, :xml, :json
	def new
		@post = Post.new()
		@team_id = params[:team_id]
	end

	def create
		@post = Post.new(
			title: params[:title],
			content: params[:content],
			member_id: params[:member_id],
			team_id: params[:team_id],
		)
		@post.save!
		member = Member.find_by_id(params[:member_id])
		member = Assignment.joins(:role).joins(:member).select("roles.name as name, roles.id as role_id, members.*").where("members.id" => params[:member_id]).take

		render :json => {content: params[:content], author: params[:author], post_id: @post.id, role_id: member.role_id}
	end

	def create_comment
		@comment = Comment.new(
			content: params[:content],
			member_id: params[:member_id],
			post_id: params[:post_id]
		)
		@comment.save!
		post = Post.find_by_id(params[:post_id])
		member = Member.find_by_id(params[:member_id])
=begin
		notif = Notification.create(
			content: member.nickname + " commented on your post.",
			team_id: team_id,
			notif_type_type: "Comment",
			notif_type_id: @comment.id,
			notif_kind: "replied"
		)
=end
		
		member = Assignment.joins(:role).joins(:member).select("roles.name as name, roles.id as role_id, members.*").where("members.id" => params[:member_id]).take

		render :json => {content: params[:content], author: params[:author], post_id: post.id, role_id: member.role_id, comment_id: @comment.id}
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
