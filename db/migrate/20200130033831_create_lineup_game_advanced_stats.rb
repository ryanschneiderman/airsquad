class CreateLineupGameAdvancedStats < ActiveRecord::Migration[5.2]
  def change
    create_table :lineup_game_advanced_stats do |t|
    	t.float :value
	  	t.belongs_to :lineup, index: true
	  	t.belongs_to :stat_list, index: true
	  	t.belongs_to :game, index: true
	  	t.json :constituent_stats
      t.timestamps
    end
  end
end
