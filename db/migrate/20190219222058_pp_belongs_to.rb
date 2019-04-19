class PpBelongsTo < ActiveRecord::Migration[5.2]
  def change
  	add_reference :play_progressions, :play, index: true
  end
end
