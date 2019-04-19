class CreateStatGranules < ActiveRecord::Migration[5.2]
  def change
    create_table :stat_granules do |t|
      t.string :metadata
      t.belongs_to :member, index: true
      t.belongs_to :game, index: true
      t.belongs_to :stat_list, index: true
      t.timestamps
    end
  end
end
