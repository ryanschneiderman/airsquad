class GameStats < ActiveRecord::Migration[5.2]
  def change
  	add_reference :game_stats, :stat, index: true
  	add_column :game_stats, :metadata, :string
  end
end
