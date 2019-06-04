class AddEffeciencyStats < ActiveRecord::Migration[5.2]
  def change
  	TeamStat.create :stat_list_id => 30, :team_id => 1, :show => true 
  	TeamStat.create :stat_list_id => 31, :team_id => 1, :show => true 
  end
end
