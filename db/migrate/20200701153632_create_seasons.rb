class CreateSeasons < ActiveRecord::Migration[5.2]
  def change
    create_table :seasons do |t|
      t.belongs_to :team, index: true
      t.integer :year1
      t.integer :year2
      t.timestamps
    end
  end
end
