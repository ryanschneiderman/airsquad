class AdvancedStatsRefs < ActiveRecord::Migration[5.2]
  def change
  	add_reference :advanced_stats, :stat_list, index: true
  	add_reference :advanced_stats, :member, index: true
  	add_reference :advanced_stats, :game, index: true
  	add_column :advanced_stats, :constituent_stats, :string
  	
  end
end
