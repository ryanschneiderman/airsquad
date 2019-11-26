class EditPlaysModel < ActiveRecord::Migration[5.2]
  def change
  	remove_column :plays, :halfcourt_fullcourt
  	 add_reference :plays, :play_types, index: true
  end
end
