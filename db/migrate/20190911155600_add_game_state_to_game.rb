class AddGameStateToGame < ActiveRecord::Migration[5.2]
  def change
  	add_column :games, :game_state, :json
  end
end
