class AddAssignments < ActiveRecord::Migration[5.2]
  def change
  	Assignment.create :member_id => 1, :role_id => 1
  	Assignment.create :member_id => 3, :role_id => 1
  	Assignment.create :member_id => 5, :role_id => 1
  	Assignment.create :member_id => 7, :role_id => 1
  	Assignment.create :member_id => 9, :role_id => 1
  	Assignment.create :member_id => 11, :role_id => 1
  	Assignment.create :member_id => 13, :role_id => 1
  	Assignment.create :member_id => 15, :role_id => 1
  	Assignment.create :member_id => 17, :role_id => 1
  	Assignment.create :member_id => 19, :role_id => 1
  	Assignment.create :member_id => 21, :role_id => 2
  	Assignment.create :member_id => 24, :role_id => 2
  	Assignment.create :member_id => 28, :role_id => 1
  	Assignment.create :member_id => 29, :role_id => 1
  	Assignment.create :member_id => 30, :role_id => 1
  end
end
