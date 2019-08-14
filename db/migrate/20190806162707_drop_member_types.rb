class DropMemberTypes < ActiveRecord::Migration[5.2]
  def change
  	remove_column :members, :isPlayer
  	remove_column :members, :isAdmin
  	remove_column :members, :isCreator
  end
end
