class DropTeamAdvancedStats < ActiveRecord::Migration[5.2]
  def change
  	drop_table :team_advanced_stats
  end
end
