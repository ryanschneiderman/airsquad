class FindLineupService
	def initialize(params)
		@ids = params[:ids]
		@season_id = params[:season_id]
	end   

	def call()
		lineup = Lineup.joins(:lineups_members).select("lineups.*, lineups_members.member_id as member_id").where("lineups_members.member_id" => @ids, "lineups.season_id" => @season_id)
		lineup = lineup.group_by{ |e| e }.select { |k, v| v.size > 4 }.map(&:first)
		return lineup[0]
	end
end