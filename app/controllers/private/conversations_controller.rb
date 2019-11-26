class Private::ConversationsController < ApplicationController
	## change to receive user_id from member
	def create
	  recipient_id = params[:user_id]
	  if Private::Conversation.where(sender_id: current_user.id, recipient_id: recipient_id).take
	  	@conversation = Private::Conversation.where(sender_id: current_user.id, recipient_id: recipient_id).take

	  else
	  	@conversation = Private::Conversation.new(sender_id: current_user.id, 
	                                           recipient_id: recipient_id)
	  	@conversation.save
	  end
	  if params[:is_messenger]
	  	redirect_to open_messenger_path(id: recipient_id, 
                            smaller_device: false, 
                            type: 'private')
	  else
		  respond_to do |format|
	        format.js {render partial: 'private/conversations/open'}
	      end
	  end
	end

	def open
	  @conversation = Private::Conversation.find(params[:id])
	  add_to_conversations unless already_added?
	  respond_to do |format|
	    format.js { render partial: 'private/conversations/open' }
	  end
	end

	def close
	  @conversation_id = params[:id].to_i
	  session[:private_conversations].delete(@conversation_id)

	  respond_to do |format|
	    format.js
	  end
	end


	private

	def add_to_conversations
	  session[:private_conversations] ||= []
	  session[:private_conversations] << @conversation.id
	end

	def already_added?
  		session[:private_conversations].include?(@conversation.id)
	end


end
