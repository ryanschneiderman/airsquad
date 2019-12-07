class CreatePracticeStats < ActiveRecord::Migration[5.2]
  def change
    create_table :practice_stats do |t|
      t.integer :value
      t.belongs_to :stat_list, index: true
      t.belongs_to :practice, index: true
      t.belongs_to :member, index: true
      t.timestamps
    end
  end
end
