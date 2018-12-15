class CreateCoaches < ActiveRecord::Migration[5.2]
  def change
    create_table :coaches do |t|
    	t.belongs_to :team, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
