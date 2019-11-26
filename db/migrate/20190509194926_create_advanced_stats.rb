class CreateAdvancedStats < ActiveRecord::Migration[5.2]
  def change
    create_table :advanced_stats do |t|

      t.timestamps
    end
  end
end
