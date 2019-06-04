class AddTeamStats < ActiveRecord::Migration[5.2]
  def change
  	TeamStat.create :stat_list_id => 46, :team_id => 1, :show => true 
  	TeamStat.create :stat_list_id => 47, :team_id => 1, :show => true 
  	TeamStat.create :stat_list_id => 48, :team_id => 1, :show => true 
  end
end
