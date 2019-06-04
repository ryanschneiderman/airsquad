class TruncateTables < ActiveRecord::Migration[5.2]
  def change
  	ActiveRecord::Base.connection.execute("TRUNCATE table stats restart identity")  
  end
end
