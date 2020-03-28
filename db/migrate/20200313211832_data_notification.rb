class DataNotification < ActiveRecord::Migration[5.2]
  def change
  	add_column :notifications, :data, :json
  end
end
