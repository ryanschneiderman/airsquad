class TeamsUpdate < ActiveRecord::Migration[5.2]
  def change
  	add_column :teams, :num_periods, :integer
  	add_column :teams, :period_length, :integer
  	add_reference :teams, :sport, index: true
  end
end
