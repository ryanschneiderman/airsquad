class ModifyPlayType < ActiveRecord::Migration[5.2]
  def change
  	rename_column :play_types, :play_type, :o_type
  	add_column :play_types, :d_type, :string
  end
end
