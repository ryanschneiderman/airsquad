class AddTeamsToSchedule < ActiveRecord::Migration[5.2]
  def change
  	add_reference :schedule_events, :team, index: true
  end
end
