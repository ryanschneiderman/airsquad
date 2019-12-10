class Stats::SortPracticeStatService
	def initialize(params)
		@practice_id = params[:practice_id]
	end

	def call
		player_arr = []
		minutes_data = PracticeStat.select("*").joins(:stat_list).select("*").joins(:member).where(practice_id: @practice_id, stat_list_id: 16)
		minutes_data = minutes_data.sort_by{|e| [e.value, e.member_id]}.reverse
		minutes_data.each do |minute_obj|
			player = Member.find_by_id(minute_obj.member_id)
			player_arr.append(player)
		end
		return player_arr
		## retrieve minutes data for game
		## sort descending
		## for each stat object, retrieve the associated player object, put in array

	end
end