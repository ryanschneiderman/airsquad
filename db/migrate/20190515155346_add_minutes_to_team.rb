class AddMinutesToTeam < ActiveRecord::Migration[5.2]
  def change
  	add_column :teams, :minutes_p_q, :integer
  end
end
