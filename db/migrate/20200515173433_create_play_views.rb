class CreatePlayViews < ActiveRecord::Migration[5.2]
  def change
    create_table :play_views do |t|
      t.belongs_to :play, index: true
      t.belongs_to :member, index: true
      t.datetime :viewed
      t.timestamps
    end
  end
end
