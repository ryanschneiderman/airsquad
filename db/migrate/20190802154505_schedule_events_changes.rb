class ScheduleEventsChanges < ActiveRecord::Migration[5.2]
  def change
  	remove_index :schedule_events, :teams_id
  end
end
