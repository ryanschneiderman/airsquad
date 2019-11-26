class AddPlayTypes1 < ActiveRecord::Migration[5.2]
  def change
  	  	PlayType.create :play_type => "Man to Man"
	  	PlayType.create :play_type => "Zone"
	  	PlayType.create :play_type => "Inbounds"
	  	PlayType.create :play_type => "Press Break"
  end
end
