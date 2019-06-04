class ClearStats2 < ActiveRecord::Migration[5.2]
  def change
  	ActiveRecord::Base.connection.execute("TRUNCATE table advanced_stats restart identity")  
  	ActiveRecord::Base.connection.execute("TRUNCATE table season_advanced_stats restart identity") 
  	ActiveRecord::Base.connection.execute("TRUNCATE table season_stats restart identity") 
  	ActiveRecord::Base.connection.execute("TRUNCATE table season_team_adv_stats restart identity") 
  	ActiveRecord::Base.connection.execute("TRUNCATE table stat_granules restart identity") 
  	ActiveRecord::Base.connection.execute("TRUNCATE table stat_totals restart identity") 
  	ActiveRecord::Base.connection.execute("TRUNCATE table team_advanced_stats restart identity") 
  	ActiveRecord::Base.connection.execute("TRUNCATE table team_season_stats restart identity") 
  end
end
