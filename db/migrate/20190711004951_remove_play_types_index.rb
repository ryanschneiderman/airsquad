class RemovePlayTypesIndex < ActiveRecord::Migration[5.2]
  def change
  	remove_index :plays, :play_types_id
  end
end
