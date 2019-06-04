class AddPaceStatList < ActiveRecord::Migration[5.2]
  def change
  	StatList.create :stat => "Pace", :granular => false, :default => false, :advanced => true, :collectable => false, :team_stat => true
  end
end
