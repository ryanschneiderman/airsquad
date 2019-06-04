class ChangeTasDt < ActiveRecord::Migration[5.2]
  def change
  	remove_column :team_advanced_stats, :value
  	add_column :team_advanced_stats, :value, :float
  end
end
