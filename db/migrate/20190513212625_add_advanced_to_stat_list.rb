class AddAdvancedToStatList < ActiveRecord::Migration[5.2]
  def change
  	add_column :stat_lists, :advanced, :boolean
  end
end
