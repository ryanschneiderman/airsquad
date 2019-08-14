class AddScheduleEventsToDb < ActiveRecord::Migration[5.2]
  def change
  	Assignment.create :member_id => "2019-08-03", :role_id => "16:00:00",
  end
end
