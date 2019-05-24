class InsertAssistsAsStat < ActiveRecord::Migration[5.2]
  def change
  	StatList.create :stat => "Assist", :granular => true, :default => false, :advanced => false, :collectable => true, :id => 3
  end
end
