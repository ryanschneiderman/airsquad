class Stats::Advanced::TeamAdvStatDependenciesService

	def initialize(params)
		@adv_stats = params[:adv_stats]
	end

	def call()
		return_arr = []
		@adv_stats.each do |adv_stat|
			stat = determine_dependencies(adv_stat.id, adv_stat.stat)
			if stat 
				return_arr.push(stat)
			end
		end
		return return_arr
	end

	private

	def determine_dependencies(stat_id, stat_name)
		case stat_id
		##off eff
		when 30
			return {stat_id: stat_id, stats_needed: [7, 4], stats_satisfied: [1,2, 13, 14, 15], name: stat_name}
		##def eff
		when 31
			return {stat_id: stat_id, stats_needed: [7, 4], stats_satisfied: [1,2, 13, 14, 15], name: stat_name}
		## poss
		when 43
			return {stat_id: stat_id, stats_needed: [7, 4], stats_satisfied: [1,2, 13, 14], name: stat_name}
		##pace
		when 48
			return {stat_id: stat_id, stats_needed: [7, 4], stats_satisfied: [1,2, 13, 14, 16], name: stat_name}
		##assist ratio
		when 52 
			return {stat_id: stat_id, stats_needed: [7, 4, 3], stats_satisfied: [1,2, 13, 14], name: stat_name}
		when 46 
			return{stat_id: stat_id, stats_needed: [4, 7], stats_satisfied: [1,2, 13,14], name: stat_name}
		end
	end
end

