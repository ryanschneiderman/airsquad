class IsOpponentToTeamAdvanced < ActiveRecord::Migration[5.2]
  def change
  	add_column :team_advanced_stats, :is_opponent, :boolean
  end
end
