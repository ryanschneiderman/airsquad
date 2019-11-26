class AddNumGamesSeasonStats < ActiveRecord::Migration[5.2]
  def change
  	add_column :season_stats, :num_games, :integer
  end
end
