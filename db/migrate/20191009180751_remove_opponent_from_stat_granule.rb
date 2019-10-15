class RemoveOpponentFromStatGranule < ActiveRecord::Migration[5.2]
  def change
  	remove_index "stat_granules", name: "index_stat_granules_on_opponent_id"
  	remove_column :stat_granules, :opponent_id
  end
end
