class IsAdminMember < ActiveRecord::Migration[5.2]
  def change
  	add_column :members, :is_admin, :boolean
  end
end
