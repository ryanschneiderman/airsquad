class RemoveAdvancedFromStats < ActiveRecord::Migration[5.2]
  def change
  	remove_column :stat_lists, :advanced
  end
end
