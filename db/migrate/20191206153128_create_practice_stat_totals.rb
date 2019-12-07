class CreatePracticeStatTotals < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_stat_totals do |t|
      t.integer :value
      t.belongs_to :stat_list, index: true
      t.belongs_to :practice, index: true
      t.belongs_to :team, index: true
      t.boolean :is_opponent
      t.timestamps
    end
  end
end
