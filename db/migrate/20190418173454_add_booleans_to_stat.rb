class AddBooleansToStat < ActiveRecord::Migration[5.2]
  def change
  	add_column :team_stats, :show, :boolean 
  	add_column :team_stats, :granule, :boolean
  	add_column :team_stats, :favorite, :boolean
  end
end
