class AddRankAdvancedStats < ActiveRecord::Migration[5.2]
  def change
  	add_column :season_advanced_stats, :team_rank, :integer
  end
end
