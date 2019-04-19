class DropTeamStats < ActiveRecord::Migration[5.2]
  def change
  	drop_table :game_stats
  end
end
