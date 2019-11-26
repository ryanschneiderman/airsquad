class DropGranularColumn < ActiveRecord::Migration[5.2]
  def change
  	remove_column :stat_lists, :granular
  	add_column :stat_lists, :is_percent, :boolean
  end
end
