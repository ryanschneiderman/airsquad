class CreateGameStats < ActiveRecord::Migration[5.2]
  def change
    create_table :game_stats do |t|
      t.string :metadata
      t.belongs_to :stat, index: true
      t.timestamps
    end
  end
end
