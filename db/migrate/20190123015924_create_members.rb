class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
    	t.boolean :isPlayer
    	t.boolean :isAdmin
    	t.boolean :isCreator
    	t.string :nickname
      t.timestamps
    end
  end
end
