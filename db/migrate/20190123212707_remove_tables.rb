class RemoveTables < ActiveRecord::Migration[5.2]
  def change
  	drop_table :players
  	drop_table :coaches
  end
end
