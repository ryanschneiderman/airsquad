class DropDateFromGames < ActiveRecord::Migration[5.2]
  def change
  	remove_column :games, :date
  end
end
