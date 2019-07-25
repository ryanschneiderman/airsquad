class CanvasWidthProgressions < ActiveRecord::Migration[5.2]
  def change
  	add_column :progressions, :canvas_width, :float
  end
end
