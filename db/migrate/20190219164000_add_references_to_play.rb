class AddReferencesToPlay < ActiveRecord::Migration[5.2]
  def change
  	add_reference :plays, :team, index: true
  	add_reference :plays, :user, index: true
  end
end
