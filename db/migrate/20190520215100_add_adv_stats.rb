class AddAdvStats < ActiveRecord::Migration[5.2]
  def change
  	StatList.create :stat => "Total Rebound %", :granular => false, :collectable => false, :default => false, :advanced => true
  	StatList.create :stat => "Opponent Possessions", :granular => false, :collectable => false, :default => false, :advanced => true
  end
end
