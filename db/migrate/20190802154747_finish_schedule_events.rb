class FinishScheduleEvents < ActiveRecord::Migration[5.2]
  def change
  	remove_column :schedule_events, :teams_id
  	add_reference :schedule_events, :team, index: true
  end
end
