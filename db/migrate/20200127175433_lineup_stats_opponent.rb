class LineupStatsOpponent < ActiveRecord::Migration[5.2]
  def change
  	add_column :lineup_stats, :is_opponent, :boolean
  	add_column :lineup_adv_stats, :is_opponent, :boolean
  end
end
