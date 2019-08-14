class AddPercentagesTeamStats < ActiveRecord::Migration[5.2]
  def change
  	TeamStat.create :stat_list_id => 27, :team_id => 1, :show => false 
  	TeamStat.create :stat_list_id => 28, :team_id => 1, :show => false
  	TeamStat.create :stat_list_id => 29, :team_id => 1, :show => false 
 
  end
end
