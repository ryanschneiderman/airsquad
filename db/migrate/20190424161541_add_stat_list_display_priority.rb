class AddStatListDisplayPriority < ActiveRecord::Migration[5.2]
  def change
  	add_column :stat_lists, :display_priority, :integer
  end
end
