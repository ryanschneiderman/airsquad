class CreatePlays < ActiveRecord::Migration[5.2]
  def change
    create_table :plays do |t|
      t.string :name
      t.boolean :offense_defense
      t.boolean :halfcourt_fullcourt
      t.timestamps
    end
  end
end
