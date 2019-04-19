class RemoveGranuleTeamStats < ActiveRecord::Migration[5.2]
  def change
  	remove_column :team_stats, :granule
  end
end
