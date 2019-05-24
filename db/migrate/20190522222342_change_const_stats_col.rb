class ChangeConstStatsCol < ActiveRecord::Migration[5.2]
  def change
  	rename_column :season_advanced_stats, :constitutent_stats, :constituent_stats 
  end
end
