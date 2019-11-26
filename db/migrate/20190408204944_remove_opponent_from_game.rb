class RemoveOpponentFromGame < ActiveRecord::Migration[5.2]
  def change
  	remove_column :games, :opponent
  end
end
