class AddAdvancedStats < ActiveRecord::Migration[5.2]
  def change
  	StatList.create :stat => "Offensive Rebound %", :granular => false, :default => false, :advanced => true, :collectable => false
  	StatList.create :stat => "Defensive Rebound %", :granular => false, :default => false, :advanced => true, :collectable => false
  	StatList.create :stat => "Rebound %", :granular => false, :default => false, :advanced => true, :collectable => false
  	StatList.create :stat => "Steal %", :granular => false, :default => false, :advanced => true, :collectable => false
  	StatList.create :stat => "Block %", :granular => false, :default => false, :advanced => true, :collectable => false
  	StatList.create :stat => "Turnover %", :granular => false, :default => false, :advanced => true, :collectable => false
  	StatList.create :stat => "Assist %", :granular => false, :default => false, :advanced => true, :collectable => false
  	StatList.create :stat => "Offensive Box Plus Minus", :granular => false, :default => false, :advanced => true, :collectable => false
  	StatList.create :stat => "Defenisve Box Plus Minus", :granular => false, :default => false, :advanced => true, :collectable => false
  	StatList.create :stat => "Box Plus Minus", :granular => false, :default => false, :advanced => true, :collectable => false
  	StatList.create :stat => "Possessions", :granular => false, :default => false, :advanced => true, :collectable => false
  end
end
