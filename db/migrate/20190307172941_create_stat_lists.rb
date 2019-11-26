class CreateStatLists < ActiveRecord::Migration[5.2]
  def change
    create_table :stat_lists do |t|
      t.string :stat 
      t.timestamps
    end
  end
end
