class DropPlayProgression < ActiveRecord::Migration[5.2]
  def change
  	drop_table :play_progressions
  end
end
