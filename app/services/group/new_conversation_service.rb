## THIS IS ASSUMING IT IS THE FIRST TIME WE ADD A USER TO AN EXISTING PRIVATE CONVERSATION; THAT IS, NOT TO AN EXISTING GROUP CONVERSATION
## MAKES SENSE TO TEST WITH THE ALREADY EXISTING USAGE OF GROUP CONVERSATION CREATION

class Group::NewConversationService

  def initialize(params)
    ## GOOD
    @creator_id = params[:creator_id]

    ## SHOULD BE AN ARRAY OF NEW USERS; WANT TO BE ABLE TO CREATE A GROUP CONVERSATION WITH MULTIPLE NEW USERS
    @user_ids = params[:user_ids]

    puts @user_ids
  end

  def call
    creator = User.find(@creator_id)

    new_group_conversation = Group::Conversation.new

    new_group_conversation.name = creator.name


    if new_group_conversation.save
      arr_of_users_ids = @user_ids

      creator.group_conversations << new_group_conversation

      @user_ids.each do |user_id|
        user = User.find(user_id)
        new_group_conversation.name += ", " + user.name
        user.group_conversations << new_group_conversation
      end

      create_initial_message(creator, arr_of_users_ids, new_group_conversation)

      new_group_conversation
    end
  end

  private

  def create_initial_message(creator, arr_of_users_ids, new_group_conversation)
    message = Group::Message.create(
      user_id: creator.id, 
      content: 'Conversation created by ' + creator.name, 
      added_new_users: arr_of_users_ids , 
      conversation_id: new_group_conversation.id
    )
  end
end