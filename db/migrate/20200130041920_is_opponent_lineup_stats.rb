class IsOpponentLineupStats < ActiveRecord::Migration[5.2]
  def change
  	add_column :lineup_game_stats, :is_opponent, :boolean
  end
end
