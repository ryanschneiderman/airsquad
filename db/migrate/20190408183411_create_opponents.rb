class CreateOpponents < ActiveRecord::Migration[5.2]
  def change
    create_table :opponents do |t|
    	t.string :name
    	t.belongs_to :game, index: true
    	t.belongs_to :team, index: true
      t.timestamps
    end
  end
end
