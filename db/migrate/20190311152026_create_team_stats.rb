class CreateTeamStats < ActiveRecord::Migration[5.2]
  def change
    create_table :team_stats do |t|
    	t.belongs_to :stat_list
    	t.belongs_to :team
      t.timestamps
    end
  end
end
