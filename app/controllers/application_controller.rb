
class ApplicationController < ActionController::Base
	before_action :opened_conversations_windows
	before_action :all_ordered_conversations
	before_action :set_user_data
	before_action :all_related_members
	before_action :authenticate_user!

	def opened_conversations_windows
	  if user_signed_in?
	    # opened conversations
	    session[:private_conversations] ||= []
	    session[:group_conversations] ||= []
	    @private_conversations_windows = Private::Conversation.includes(:recipient, :messages)
	                                         .find(session[:private_conversations])
	    @group_conversations_windows = Group::Conversation.find(session[:group_conversations])
	  else
	    @private_conversations_windows = []
	    @group_conversations_windows = []
	  end
	end

	def all_ordered_conversations 
	  if user_signed_in?
	    @all_conversations = OrderConversationsService.new({user: current_user}).call
	  end
	end 

	## try to condense into one query
	def all_related_members
		if user_signed_in?
			@all_related_members = []
			teams_belonging_to_user = Team.joins(:members).where(members: {user_id: current_user.id})
			teams_belonging_to_user.each do |team|
				members = Member.where(team_id: team.id)
				members.each do |member|
					if member.user_id != current_user.id
						@all_related_members.push(User.find_by_id(member.user_id))
					end
				end
			end
		end
	end

	def set_user_data
	  if user_signed_in?
	    gon.group_conversations = current_user.group_conversations.ids
	    gon.user_id = current_user.id
	    cookies[:user_id] = current_user.id if current_user.present?
	    cookies[:group_conversations] = current_user.group_conversations.ids
	  else
	    gon.group_conversations = []
	  end
	end
end
