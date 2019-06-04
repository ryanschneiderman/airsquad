class FtRateStatList < ActiveRecord::Migration[5.2]
  def change
  	StatList.create :stat => "FT rate", :granular => false, :default => false, :advanced => true, :collectable => false, :team_stat => false
  end
end
