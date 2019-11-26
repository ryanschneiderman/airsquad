class RenameSeasonStats < ActiveRecord::Migration[5.2]
  def change
  	rename_column :season_stats, :game_average, :per_game
  end
end
