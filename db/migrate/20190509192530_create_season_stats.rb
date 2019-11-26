class CreateSeasonStats < ActiveRecord::Migration[5.2]
  def change
    create_table :season_stats do |t|
      t.belongs_to :stat_list, index: true
      t.belongs_to :member, index: true
      t.integer :total
      t.timestamps
    end
  end
end
