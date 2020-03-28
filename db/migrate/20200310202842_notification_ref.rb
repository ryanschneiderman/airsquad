class NotificationRef < ActiveRecord::Migration[5.2]
  def change
  	add_reference :notifications, :notif_type, polymorphic: true
  end
end
