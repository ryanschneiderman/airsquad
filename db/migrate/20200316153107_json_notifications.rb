class JsonNotifications < ActiveRecord::Migration[5.2]
  def change
  	remove_column :notifications, :data
  	add_column :notifications, :data, :jsonb, default: "{}"
  end
end
