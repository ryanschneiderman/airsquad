class GameSeasons < ActiveRecord::Migration[5.2]
  def change
  	add_reference :games, :season, index: true
  end
end
