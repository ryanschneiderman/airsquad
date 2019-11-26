class TruncateStatsService
	def initialize()
	end

	def call()
		ActiveRecord::Base.connection.execute("delete from season_team_adv_stats * where team_id = 3")
		ActiveRecord::Base.connection.execute("delete from stat_totals * where team_id = 3")
		ActiveRecord::Base.connection.execute("delete from team_season_stats * where team_id = 3")
		ActiveRecord::Base.connection.execute("delete from team_advanced_stats A using games B where B.id = A.game_id AND B.team_id = 3")
		ActiveRecord::Base.connection.execute("delete from advanced_stats A using members B where B.id = A.member_id AND B.team_id = 3")
		ActiveRecord::Base.connection.execute("delete from season_advanced_stats A using members B where B.id = A.member_id AND B.team_id = 3")
		ActiveRecord::Base.connection.execute("delete from season_stats A using members B where B.id = A.member_id AND B.team_id = 3")
		ActiveRecord::Base.connection.execute("delete from stat_granules A using members B where B.id = A.member_id AND B.team_id = 3")
		ActiveRecord::Base.connection.execute("delete from stats A using members B where B.id = A.member_id AND B.team_id = 3")
		ActiveRecord::Base.connection.execute("update games set played = false where team_id = 3")
		ActiveRecord::Base.connection.execute("update members set games_played = 0 where team_id = 3")
		ActiveRecord::Base.connection.execute("update members set season_minutes = 0 where team_id = 3")
	end
end

