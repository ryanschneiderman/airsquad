include Shared::ConversationsHelper

module Private::ConversationsHelper
	def private_conv_recipient(conversation)
	  conversation.opposed_user(current_user)
	end

	def load_private_messages(conversation)
	  if conversation.messages.count > 0 
	    'private/conversations/conversation/messages_list/link_to_previous_messages'
	  else
	    'shared/empty_partial'
	  end 
	end

	def recipient_is_related_member?
		@all_related_members.find {|member| member.id == @recipient.id}.present?	
	end

	def create_group_conv_partial_path
	  if recipient_is_related_member?
	    'private/conversations/conversation/heading/create_group_conversation'
	  else
	    'shared/empty_partial'
	  end
	end
end
