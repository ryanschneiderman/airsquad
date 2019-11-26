class AddPlayedBooleanToGame < ActiveRecord::Migration[5.2]
  def change
  	add_column :games, :played, :boolean
  end
end
