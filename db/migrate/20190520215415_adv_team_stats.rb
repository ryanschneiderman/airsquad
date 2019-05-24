class AdvTeamStats < ActiveRecord::Migration[5.2]
  def change
  	TeamStat.create :team_id => 1, :stat_list_id => 44, :show => true
  	TeamStat.create :team_id => 1, :stat_list_id => 45, :show => true
  end
end
