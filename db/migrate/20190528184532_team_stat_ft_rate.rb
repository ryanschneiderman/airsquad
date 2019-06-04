class TeamStatFtRate < ActiveRecord::Migration[5.2]
  def change
  	TeamStat.create :stat_list_id => 49, :team_id => 1, :show => true 
  end
end
