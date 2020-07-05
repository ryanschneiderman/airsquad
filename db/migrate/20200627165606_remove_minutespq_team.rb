class RemoveMinutespqTeam < ActiveRecord::Migration[5.2]
  def change
  	remove_column :teams, :minutes_p_q
  end
end
