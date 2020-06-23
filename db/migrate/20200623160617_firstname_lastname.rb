class FirstnameLastname < ActiveRecord::Migration[5.2]
  def change
  	remove_column :users, :name
  	add_column :users, :first_name, :string, default: ""
  	add_column :users, :last_name, :string, default: ""
  end
end
