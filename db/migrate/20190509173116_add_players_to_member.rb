class AddPlayersToMember < ActiveRecord::Migration[5.2]
  def change
  	 Member.create :isPlayer => true, :isAdmin => false, :isCreator => false, :nickname => "Logan", :user_id => 19, :team_id =>1
  	 Member.create :isPlayer => true, :isAdmin => false, :isCreator => false, :nickname => "Oliver", :user_id => 17, :team_id =>1
  	 Member.create :isPlayer => true, :isAdmin => false, :isCreator => false, :nickname => "Russell", :user_id => 15, :team_id =>1
  end
end
