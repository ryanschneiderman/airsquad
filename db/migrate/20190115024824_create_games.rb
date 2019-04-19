class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
    	t.string :opponent
    	t.date :date
    	t.belongs_to :team, index: true
      t.timestamps
    end
  end
end
