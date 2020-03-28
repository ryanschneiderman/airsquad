class RemoveNotifReference < ActiveRecord::Migration[5.2]
  def change
  	remove_reference :notifications, :not_type, :polymorphic => true
  end
end
