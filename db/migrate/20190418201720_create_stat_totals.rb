class CreateStatTotals < ActiveRecord::Migration[5.2]
  def change
    create_table :stat_totals do |t|
      t.belongs_to :stat_list, index: true
      t.belongs_to :team, index: true
      t.belongs_to :game, index: true
      t.integer :total
      t.timestamps
    end
  end
end
