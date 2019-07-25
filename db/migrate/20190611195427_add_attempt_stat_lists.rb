class AddAttemptStatLists < ActiveRecord::Migration[5.2]
  def change
  	StatList.create :stat => "Field goal attempts", :granular => true, :default => true, :advanced => false, :collectable => false, :team_stat => false
  	StatList.create :stat => "3 point attempts", :granular => true, :default => true, :advanced => false, :collectable => false, :team_stat => false
  	StatList.create :stat => "Free throw attempts", :granular => true, :default => true, :advanced => false, :collectable => false, :team_stat => false
  end
end
