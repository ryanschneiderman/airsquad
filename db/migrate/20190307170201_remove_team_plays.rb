class RemoveTeamPlays < ActiveRecord::Migration[5.2]
  def change
  	drop_table :team_plays 
  end
end
