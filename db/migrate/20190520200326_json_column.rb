class JsonColumn < ActiveRecord::Migration[5.2]
  def change
  	remove_column :advanced_stats, :constituent_stats
  end
end
