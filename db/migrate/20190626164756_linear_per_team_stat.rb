class LinearPerTeamStat < ActiveRecord::Migration[5.2]
  def change
  	TeamStat.create :stat_list_id => 20, :team_id => 1, :show => true 
  end
end
