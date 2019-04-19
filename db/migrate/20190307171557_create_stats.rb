class CreateStats < ActiveRecord::Migration[5.2]
  def change
    create_table :stats do |t|
    	t.integer :value
      t.belongs_to :stat_list, index: true
      t.belongs_to :game, index: true
      t.belongs_to :member, index: true
      t.timestamps
    end
  end
end
