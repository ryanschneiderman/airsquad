class MinutesGamesMemberRel < ActiveRecord::Migration[5.2]
  def change
  	add_column :members, :season_minutes, :integer
  	add_column :members, :games_played, :integer
  	rename_column :season_stats, :num_games, :per_game_rank
  	add_column :season_stats, :per_minute_rank, :integer
  	remove_column :season_stats, :per_game 
  end
end
