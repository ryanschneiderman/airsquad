class PlayTeamOptional < ActiveRecord::Migration[5.2]
  def change
  	remove_column :plays, :team_id
  	add_reference :plays, :team, index: true, optional: true
  end
end
