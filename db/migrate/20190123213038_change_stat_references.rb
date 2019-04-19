class ChangeStatReferences < ActiveRecord::Migration[5.2]
  def change
  	change_table :stats do |t|
      t.remove :player_id
      t.belongs_to :member, index:true
    end
  end
end
