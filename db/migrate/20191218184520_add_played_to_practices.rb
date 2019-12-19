class AddPlayedToPractices < ActiveRecord::Migration[5.2]
  def change
  	add_column :practices, :played, :boolean
  end
end
