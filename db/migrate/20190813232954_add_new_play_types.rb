class AddNewPlayTypes < ActiveRecord::Migration[5.2]
  def change
  	remove_column :play_types, :type 
  	add_column :play_types, :play_type, :string
  	PlayType.create :play_type => "halfcourt"
	PlayType.create :play_type => "fullcourt"
  end
end
