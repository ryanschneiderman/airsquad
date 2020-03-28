class AddNotificationKind < ActiveRecord::Migration[5.2]
  def change
  	add_column :notifications, :notif_kind, :string
  end
end
