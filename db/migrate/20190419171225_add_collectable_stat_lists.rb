class AddCollectableStatLists < ActiveRecord::Migration[5.2]
  def change
  	add_column :stat_lists, :collectable, :boolean
  end
end
