class AddIndexToPlay < ActiveRecord::Migration[5.2]
  def change
  	remove_column :plays, :play_types_id
  	add_reference :plays, :play_type, index: true
  end
end
