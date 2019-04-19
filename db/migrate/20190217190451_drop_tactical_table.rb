class DropTacticalTable < ActiveRecord::Migration[5.2]
  def change
  	drop_table :tactical_objects
  end
end
