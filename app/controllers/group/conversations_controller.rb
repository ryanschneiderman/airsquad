class Group::ConversationsController < ApplicationController

	  def create
	    @conversation = create_group_conversation
	    add_to_conversations unless already_added?
	    if params[:is_messenger]
	  		redirect_to open_messenger_path(smaller_device: false, type: 'group', group_conversation_id: @conversation.id)
	  	end
	  end

	  def open
		  @conversation = Group::Conversation.find(params[:id])
		  add_to_conversations unless already_added?
		  respond_to do |format|
		    format.js { render partial: 'group/conversations/open' }
		  end
		end

		def close
		  @conversation = Group::Conversation.find(params[:id])

		  session[:group_conversations].delete(@conversation.id)

		  respond_to do |format|
		    format.js
		  end
		end

		def update
		  Group::AddUserToConversationService.new({
		    conversation_id: params[:id],
		    new_user_id: params[:user][:id],
		    added_by_id: params[:added_by]
		  }).call
		end
	  
	  private

	  def add_to_conversations
	    session[:group_conversations] ||= []
	    session[:group_conversations] << @conversation.id
	  end
	 
	  def already_added?
	    session[:group_conversations].include?(@conversation.id)
	  end

	  def create_group_conversation
	    Group::NewConversationService.new({
	      creator_id: params[:creator_id],
	      user_ids: params[:user_ids]
	    }).call
	  end
end
