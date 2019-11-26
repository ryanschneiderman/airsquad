class MemberNullFalse < ActiveRecord::Migration[5.2]
  def change
	change_column_default :members, :isPlayer, false
	change_column_default :members, :isAdmin, false
	change_column_default :members, :isCreator, false
  end
end
