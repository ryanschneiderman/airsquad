class LineupSeasonId < ActiveRecord::Migration[5.2]
  def change
  	add_reference :lineups, :season, index: true
  end
end
