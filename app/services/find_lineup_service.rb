class FindLineupService
	def initialize(params)
		@ids = params[:ids]
	end   

	def call()
		lineup = Lineup.joins("join lineups_members on lineups.id = lineups_members.lineup_id").select("lineups.*, lineups_members.member_id as member_id").where("lineups_members.member_id" => @ids)
		lineup = lineup.group_by{ |e| e }.select { |k, v| v.size > 4 }.map(&:first)
		return lineup[0]
	end
end