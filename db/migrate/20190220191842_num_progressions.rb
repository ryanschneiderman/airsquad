class NumProgressions < ActiveRecord::Migration[5.2]
  def change
  	add_column :plays, :num_progressions, :integer
  end
end
