class CreatePractices < ActiveRecord::Migration[5.2]
  def change
    create_table :practices do |t|
      t.belongs_to :team, index: true
      t.belongs_to :schedule_event, index: true
      t.boolean :is_scrimmage
      t.json :game_state
      t.timestamps
    end
  end
end
