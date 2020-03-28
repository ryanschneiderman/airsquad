class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :content
      t.references :not_type, polymorphic: true
      t.boolean :viewed
      t.belongs_to :team, index: true
      t.belongs_to :member, index: true
      t.timestamps
    end
  end
end
