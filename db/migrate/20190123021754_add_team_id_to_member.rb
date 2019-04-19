class AddTeamIdToMember < ActiveRecord::Migration[5.2]
  def change
  	add_reference :members, :team, index: true
  end
end
