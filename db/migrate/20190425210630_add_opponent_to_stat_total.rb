class AddOpponentToStatTotal < ActiveRecord::Migration[5.2]
  def change
  	add_column :stat_totals, :is_opponent, :boolean
  end
end
