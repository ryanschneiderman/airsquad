class DeleteTeamService
	def initialize()
	end

	def call()
		ActiveRecord::Base.connection.execute("delete from season_team_adv_stats * where team_id = 1")
		ActiveRecord::Base.connection.execute("delete from stat_totals * where team_id = 1")
		ActiveRecord::Base.connection.execute("delete from team_season_stats * where team_id = 1")
		ActiveRecord::Base.connection.execute("delete from team_advanced_stats A using games B where B.id = A.game_id AND B.team_id = 1")
		ActiveRecord::Base.connection.execute("delete from advanced_stats A using members B where B.id = A.member_id AND B.team_id = 1")
		ActiveRecord::Base.connection.execute("delete from season_advanced_stats A using members B where B.id = A.member_id AND B.team_id = 1")
		ActiveRecord::Base.connection.execute("delete from season_stats A using members B where B.id = A.member_id AND B.team_id = 1")
		ActiveRecord::Base.connection.execute("delete from stat_granules A using members B where B.id = A.member_id AND B.team_id = 1")
		ActiveRecord::Base.connection.execute("delete from stats A using members B where B.id = A.member_id AND B.team_id = 1")
		ActiveRecord::Base.connection.execute("delete from lineup_stats A using lineups B where B.id = A.lineup_id AND B.team_id = 1")
		ActiveRecord::Base.connection.execute("delete from assignments A using members B where B.id = A.member_id AND B.team_id = 1")

		ActiveRecord::Base.connection.execute("delete from members * where team_id = 1")
		ActiveRecord::Base.connection.execute("delete from team_stats * where team_id = 1")
		ActiveRecord::Base.connection.execute("delete from opponents * where team_id = 1")
		ActiveRecord::Base.connection.execute("delete from games * where team_id = 1")
		ActiveRecord::Base.connection.execute("delete from lineups * where team_id = 1")
		ActiveRecord::Base.connection.execute("delete from posts * where team_id = 1")
		ActiveRecord::Base.connection.execute("delete from schedule_events * where team_id = 1")
		ActiveRecord::Base.connection.execute("delete from teams * where id = 1")
	end
end


