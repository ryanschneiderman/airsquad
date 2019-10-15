class AddStatDescription < ActiveRecord::Migration[5.2]
  def change
  	add_column :stat_lists, :stat_description, :text
  end
end
