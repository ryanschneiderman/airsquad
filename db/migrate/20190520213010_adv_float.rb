class AdvFloat < ActiveRecord::Migration[5.2]
  def change
  	change_column :advanced_stats, :value, :float
  end
end
