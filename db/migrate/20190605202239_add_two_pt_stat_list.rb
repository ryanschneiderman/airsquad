class AddTwoPtStatList < ActiveRecord::Migration[5.2]
  def change
  	StatList.create :stat => "2 point make", :granular => true, :default => true, :advanced => false, :collectable => false
  	StatList.create :stat => "2 point miss", :granular => true, :default => true, :advanced => false, :collectable => false
  end
end
