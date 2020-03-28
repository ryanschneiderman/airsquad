class NotificationViewed < ActiveRecord::Migration[5.2]
  def change
  	remove_column :notifications, :viewed
  end
end
