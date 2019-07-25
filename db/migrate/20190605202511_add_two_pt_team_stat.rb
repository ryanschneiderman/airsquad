class AddTwoPtTeamStat < ActiveRecord::Migration[5.2]
  def change
  	TeamStat.create :stat_list_id => 9, :team_id => 1, :show => false 
  	TeamStat.create :stat_list_id => 10, :team_id => 1, :show => false 
  end
end
