class AdvStatDependenciesService

	def initialize(params)
		@adv_stats = params[:adv_stats]
	end

	def call()
		return_arr = []
		@adv_stats.each do |adv_stat|
			puts adv_stat.id
			return_arr.push(determine_dependencies(adv_stat.id, adv_stat.stat))
		end
		return return_arr
	end

	private

	def determine_dependencies(stat_id, stat_name)
		case stat_id

		##linear PER
		when 20
			return [ stat_id, [3,4,5,6,7,8,17], [1, 2, 11, 12, 13, 14, 16, ], stat_name]

		##usage rate
		when 23
			return [ stat_id, [ 7, ], [1, 2, 13, 14, 16], stat_name]

		## offensive rating
		when 24
			return [ stat_id, [ 3, 4, 5, 7 ], [1, 2, 9, 10 , 11, 12,13, 14, 15, 16], stat_name]

		##defensive rating
		when 25
			return [ stat_id, [4,5,6,7,8 ], [1, 2, 9, 10, 13, 14, 15, 16], stat_name]

		##net rating
		when 26
			return [ stat_id, [ 3, 4, 5, 6, 7, 8, ], [1, 2, 9, 10 , 11, 12,13, 14, 15, 16], stat_name]

		##off reb%
		when 33
			return [stat_id, [ 4,5 ], [16], stat_name]
		##def reb%
		when 34
			return [ stat_id, [ 4,5 ], [16], stat_name]
		##reb %
		when 35
			return [ stat_id, [ 4,5 ], [16], stat_name]
		## steal%
		when 36
			return [ stat_id, [ 8 ], [1, 2, 11, 12, 16], stat_name]
		## block %
		when 37
			return [ stat_id, [ 8 ], [1, 2, 11, 12,16], stat_name]
		## turnover%
		when 38
			return [ stat_id, [ 7 ], [1, 2, 13, 14], stat_name]
		## assist %
		when 39
			return [ stat_id, [ 3 ], [1, 2, 16], stat_name]
		## off box plus minus
		when 40
			return [ stat_id, [ 3, 4, 5, 6, 7, 8, ], [1, 2, 9, 10 , 11, 12,13, 14, 15, 16], stat_name]
		## def box plus minus
		when 41
			return [ stat_id, [ 3, 4, 5, 6, 7, 8, ], [1, 2, 9, 10 , 11, 12,13, 14, 15, 16], stat_name]
		## box plus minus
		when 42
			return [ stat_id, [ 3, 4, 5, 6, 7, 8, ], [1, 2, 9, 10 , 11, 12,13, 14, 15, 16], stat_name]
		end

	end
end

=begin
effective fg = 18
true shooting = 19
linear PER = 20
3pt attempt rate = 21
free throw attempt rate = 22
usage rate = 23
Offensive rating = 24
defensive rating = 25
net rating = 26
off_reb % = 33
def_reb % = 34
reb% = 35
steal% = 36
block% = 37
turnover% = 38
assist% = 39
off_box plus minus = 40
def_box plus minus = 41
box plus minus = 42


possessions = 43

=end