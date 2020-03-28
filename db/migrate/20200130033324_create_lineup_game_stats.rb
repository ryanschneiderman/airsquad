class CreateLineupGameStats < ActiveRecord::Migration[5.2]
  def change
    create_table :lineup_game_stats do |t|
    	t.integer :value
	  	t.belongs_to :lineup, index: true
	  	t.belongs_to :stat_list, index: true
	  	t.belongs_to :game, index: true
      t.timestamps
    end
  end
end
