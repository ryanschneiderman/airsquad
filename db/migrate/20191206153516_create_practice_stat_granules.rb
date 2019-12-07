class CreatePracticeStatGranules < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_stat_granules do |t|
      t.json :metadata
      t.belongs_to :practice, index: true
      t.belongs_to :member, index: true
      t.belongs_to :stat_list, index: true
      t.timestamps
    end
  end
end
