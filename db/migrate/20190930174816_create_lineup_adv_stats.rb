class CreateLineupAdvStats < ActiveRecord::Migration[5.2]
  def change
    create_table :lineup_adv_stats do |t|
      t.belongs_to :stat_list, index: true
      t.belongs_to :lineup, index: true
      t.json :constituent_stats
      t.integer :rank
      t.float :value
      t.timestamps
    end
  end
end
