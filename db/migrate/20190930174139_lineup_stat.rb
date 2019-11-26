class LineupStat < ActiveRecord::Migration[5.2]
  def change
  	create_table :lineup_stats do |t|
  		t.integer :value
	  	t.belongs_to :lineup, index: true
	  	t.belongs_to :stat_list, index: true
	  	t.integer :rank
	  	t.timestamps
	  end
  end
end
