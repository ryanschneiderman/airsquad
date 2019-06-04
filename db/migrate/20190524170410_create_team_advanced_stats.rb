class CreateTeamAdvancedStats < ActiveRecord::Migration[5.2]
  def change
    create_table :team_advanced_stats do |t|
      t.belongs_to :stat_list
      t.belongs_to :game
      t.boolean :value
      t.json :constituent_stats
      t.timestamps
    end
  end
end
