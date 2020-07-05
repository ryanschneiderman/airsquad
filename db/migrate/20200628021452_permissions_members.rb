class PermissionsMembers < ActiveRecord::Migration[5.2]
  def change
  	add_column :members, :permissions, :jsonb
  end
end
