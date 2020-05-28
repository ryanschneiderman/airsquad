class RenameDeleteFlag < ActiveRecord::Migration[5.2]
  def change
  	rename_column :plays, :delete_flag, :deleted_flag
  end
end
