class MakeStatReferencesOptional < ActiveRecord::Migration[5.2]
  def change
  	remove_column :stats, :member_id
  	remove_column :stat_granules, :member_id
  	add_reference :stats, :member, index: true, optional: true
  	add_reference :stat_granules, :member, index: true, optional: true
  	add_reference :stats, :opponent, index: true, optional: true
  	add_reference :stat_granules, :opponent, index: true, optional: true
  end
end
