class RemoveIndices < ActiveRecord::Migration[5.2]
  def change
  	remove_column :stats, :member_id
  	remove_column :stat_granules, :member_id
  	remove_column :stats, :opponent_id
  	remove_column :stat_granules, :opponent_id
  	add_belongs_to :stats, :member, optional: true
  	add_belongs_to :stat_granules, :member, optional: true
  	add_belongs_to :stats, :opponent, optional: true
  	add_belongs_to :stat_granules, :opponent, optional: true
  end
end
