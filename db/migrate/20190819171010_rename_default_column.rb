class RenameDefaultColumn < ActiveRecord::Migration[5.2]
  def change
  	rename_column :stat_lists, :default, :default_stat
  end
end
