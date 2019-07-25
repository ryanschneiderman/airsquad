class AddOffenseDefenseStatList < ActiveRecord::Migration[5.2]
  def change
  	add_column :stat_lists, :stat_kind, :integer
  end
end
