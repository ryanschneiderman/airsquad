class AddRankableStatList < ActiveRecord::Migration[5.2]
  def change
  	add_column :stat_lists, :rankable, :boolean
  end
end
