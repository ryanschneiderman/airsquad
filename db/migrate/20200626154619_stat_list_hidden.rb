class StatListHidden < ActiveRecord::Migration[5.2]
  def change
  	add_column :stat_lists, :hidden, :boolean, default: false
  end
end
