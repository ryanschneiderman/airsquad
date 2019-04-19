class DropStats < ActiveRecord::Migration[5.2]
  def change
  	drop_table :stats
  end
end
