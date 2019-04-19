class AddTeamStatsStatlist < ActiveRecord::Migration[5.2]
  def change
  	add_column :stat_lists, :team_stat, :boolean
  end
end
