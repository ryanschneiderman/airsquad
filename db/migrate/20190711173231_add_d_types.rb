class AddDTypes < ActiveRecord::Migration[5.2]
  def change
  		PlayType.where(:id => 1).update_all(:d_type => "Man to Man")
  		PlayType.where(:id => 2).update_all(:d_type => "Zone")
  		PlayType.where(:id => 3).update_all(:d_type => "Inbounds")
  		PlayType.where(:id => 4).update_all(:d_type => "Press")
  end
end
