class CreateTeamSeasonStats < ActiveRecord::Migration[5.2]
  def change
    create_table :team_season_stats do |t|
      t.belongs_to :stat_list, index: true
      t.belongs_to :team, index: true
      t.float :value
      t.boolean :is_opponent
      t.timestamps
    end
  end
end
