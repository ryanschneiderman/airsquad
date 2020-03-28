class MemberNotifTypo < ActiveRecord::Migration[5.2]
  def change
  	remove_reference :member_notifs, :notifaction, :index => true
  	add_reference :member_notifs, :notification, :index => true
  end
end
