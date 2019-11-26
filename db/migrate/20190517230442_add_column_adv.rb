class AddColumnAdv < ActiveRecord::Migration[5.2]
  def change
  	add_column :advanced_stats, :value, :integer
  end
end
