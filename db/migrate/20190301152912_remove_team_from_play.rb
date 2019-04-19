class RemoveTeamFromPlay < ActiveRecord::Migration[5.2]
  def change
  	remove_column :plays, :team_id
  end
end
