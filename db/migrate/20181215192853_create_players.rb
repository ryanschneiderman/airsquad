class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
    	t.belongs_to :team, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
