class MetadataToJson < ActiveRecord::Migration[5.2]
  def change
  	change_column :stat_granules, :metadata, :json, using: 'metadata::JSON'
  end
end
