class IsOpponentLineupAdv < ActiveRecord::Migration[5.2]
  def change
  	add_column :lineup_game_advanced_stats, :is_opponent, :boolean
  end
end
