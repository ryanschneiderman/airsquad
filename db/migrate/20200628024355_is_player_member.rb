class IsPlayerMember < ActiveRecord::Migration[5.2]
  def change
  	add_column :members, :is_player, :boolean
  end
end
