class CreateSeasonAdvancedStats < ActiveRecord::Migration[5.2]
  def change
    create_table :season_advanced_stats do |t|
      t.belongs_to :stat_list, index: true
      t.belongs_to :member, index: true
      t.float :value
      t.json :constitutent_stats
      t.timestamps
    end
    rename_column :season_stats, :total, :value
  end
end
