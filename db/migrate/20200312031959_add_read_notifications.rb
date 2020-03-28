class AddReadNotifications < ActiveRecord::Migration[5.2]
  def change
  	add_column :member_notifs, :read, :boolean
  end
end
