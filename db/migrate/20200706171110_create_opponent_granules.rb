class CreateOpponentGranules < ActiveRecord::Migration[5.2]
  def change
    create_table :opponent_granules do |t|
      t.json :metadata
      t.belongs_to :opponent, index: true 
      t.belongs_to :game, index: true
      t.belongs_to :stat_list, index: true
      t.belongs_to :season, index: true
      t.timestamps
    end
  end
end
