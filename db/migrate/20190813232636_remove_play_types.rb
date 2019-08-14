class RemovePlayTypes < ActiveRecord::Migration[5.2]
  def change
  	remove_column :play_types, :o_type
  	remove_column :play_types, :d_type
  	add_column :play_types, :type, :string
  end
end
