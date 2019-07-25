class AddPlayTypes < ActiveRecord::Migration[5.2]
  def change
  	rename_column :play_types, :type, :play_type
  end
end
