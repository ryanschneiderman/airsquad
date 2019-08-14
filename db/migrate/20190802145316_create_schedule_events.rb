class CreateScheduleEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :schedule_events do |t|
      t.date :date
      t.time :time
      t.string :place
      t.string :name
      t.timestamps
    end
  end
end
