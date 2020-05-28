class PlayDeleteFlag < ActiveRecord::Migration[5.2]
  def change
  	add_column :plays, :delete_flag, :boolean
  end
end
