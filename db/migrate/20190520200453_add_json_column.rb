class AddJsonColumn < ActiveRecord::Migration[5.2]
  def change
  	add_column :advanced_stats, :constituent_stats, :json 
  end
end
