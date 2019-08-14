class AddScheduleToGames < ActiveRecord::Migration[5.2]
  def change
  	add_reference :games, :schedule_event, index: true
  end
end
