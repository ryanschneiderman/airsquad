class CreateProgressions < ActiveRecord::Migration[5.2]
  def change
    create_table :progressions do |t|
      t.string :json_diagram
      t.integer :index 
      t.belongs_to :play, index: true
      t.timestamps
    end
  end
end
