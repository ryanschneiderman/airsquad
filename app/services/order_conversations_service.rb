class OrderConversationsService

  def initialize(params)
    @user = params[:user]
  end

  # get and order conversations by last messages' dates in descending order
  ## FOR LATER keep conversations sorted in the table
  ## or add field in conversation table that keeps track of update date (!!)
  def call
    all_private_conversations = Private::Conversation.all_by_user(@user.id)
                                                     .includes(:messages)
    all_group_conversations = @user.group_conversations.includes(:messages)
    all_conversations = all_private_conversations + all_group_conversations

    ##filtered_conversations = []

    ##all_conversations.each do |conv|
    ##  empty_conversations << conv if conv.messages.last
    ##end

    ##filtered_conversations = filtered_conversations.sort{ |a, b|
    ##    b.messages.last.created_at <=> a.messages.last.created_at
    ##}

    return all_conversations
  end

end