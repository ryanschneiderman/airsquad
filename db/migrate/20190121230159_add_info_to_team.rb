class AddInfoToTeam < ActiveRecord::Migration[5.2]
  def change
  	 add_column :teams, :state, :string
  	 add_column :teams, :region, :string
  	 add_column :teams, :division, :integer
  end
end
