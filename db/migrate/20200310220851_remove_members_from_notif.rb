class RemoveMembersFromNotif < ActiveRecord::Migration[5.2]
  def change
  	remove_reference :notifications, :member, :index => true
  end
end
