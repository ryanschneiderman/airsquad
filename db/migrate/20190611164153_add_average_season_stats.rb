class AddAverageSeasonStats < ActiveRecord::Migration[5.2]
  def change
  	add_column :season_stats, :game_average, :float 
  end
end
