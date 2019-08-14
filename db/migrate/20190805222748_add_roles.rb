class AddRoles < ActiveRecord::Migration[5.2]
  def change
  	Role.create :name => "Player"
  	Role.create :name => "Admin"
  	Role.create :name => "Manager"
  	Role.create :name => "Owner"
  end
end
