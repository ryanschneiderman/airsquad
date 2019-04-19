class AddOpponentIDtoGame < ActiveRecord::Migration[5.2]
  def change
  	add_column :games, :opponent_id, :bigint
  end
end
