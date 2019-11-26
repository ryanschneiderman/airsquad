class AddIndicesToMember < ActiveRecord::Migration[5.2]
  def change
  	add_reference :members, :user, index: true
  end
end
