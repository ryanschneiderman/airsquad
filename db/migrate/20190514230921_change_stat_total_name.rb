class ChangeStatTotalName < ActiveRecord::Migration[5.2]
  def change
  	rename_column :stat_totals, :total, :value
  end
end
