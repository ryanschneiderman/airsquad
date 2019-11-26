class AddMinutesToLineup < ActiveRecord::Migration[5.2]
  def change
  	add_column :lineups, :season_minutes, :integer
  end
end
