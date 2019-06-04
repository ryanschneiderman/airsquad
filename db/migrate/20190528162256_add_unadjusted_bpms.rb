class AddUnadjustedBpms < ActiveRecord::Migration[5.2]
  def change
  	StatList.create :stat => "Unadjusted Box Plus Minus", :granular => false, :default => false, :advanced => true, :collectable => false
  	StatList.create :stat => "Unadjusted Offensive Box Plus Minus", :granular => false, :default => false, :advanced => true, :collectable => false
  end
end
