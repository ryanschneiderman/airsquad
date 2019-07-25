class AddTextProgression < ActiveRecord::Migration[5.2]
  def change
  	add_column :progressions, :notes, :text
  end
end
