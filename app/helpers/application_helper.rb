
require 'navigation_helper.rb'
require 'registration_helper.rb'
require 'private/conversations_helper.rb'
require 'private/messages_helper.rb'
require 'group/conversations_helper.rb'
require 'group/messages_helper.rb'

module ApplicationHelper
  include NavigationHelper
  include RegistrationHelper
  include Private::ConversationsHelper
  include Private::MessagesHelper
  include Group::ConversationsHelper
  include Group::MessagesHelper

  def private_conversations_windows
	  params[:controller] != 'messengers' ? @private_conversations_windows : []
	end

	def group_conversations_windows
	  params[:controller] != 'messengers' ? @group_conversations_windows : []
	end

  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  
end

