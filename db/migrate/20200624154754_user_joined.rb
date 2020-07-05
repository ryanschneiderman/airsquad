class UserJoined < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :joined, :boolean, default: false
  end
end
