class AddBooleansToGranular < ActiveRecord::Migration[5.2]
  def change
  	add_column :stat_lists, :granular, :boolean 
  	add_column :stat_lists, :advanced, :boolean 
  	add_column :stat_lists, :default, :boolean
  end
end
