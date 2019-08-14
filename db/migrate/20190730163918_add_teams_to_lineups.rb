class AddTeamsToLineups < ActiveRecord::Migration[5.2]
  def change
  	add_reference :lineups, :team, index: true
  end
end
