## create granule objects for each granule in granules (its an array)
## create player_stat objects for each player_stat in player_stats (its an array)
## save them both 
## redirect to game path

require 'json'

class SubmitPracticeModeService

	def initialize(params)
		@player_stats = params[:player_stats]
		@team_id = params[:team_id]
		@game_id = params[:game_id]
		@team_stats = params[:team_stats]
		@opponent_obj = params[:opponent_stats]
		if @opponent_obj["cumulative_arr"] 
			@opponent_stats =  @opponent_obj["cumulative_arr"]
		else
			@opponent_stats =  @opponent_obj
		end
		@team_id = params[:team_id]
		@practice_id = params[:practice_id]
	end

	def call
		create_team_stats()
		create_opponent_stats()
		create_player_stats()
	end

	private

	def create_team_stats()
		## create team cumulative totals for each stat
		@team_stats.each do |stat|
			puts stat[1]["total"]
			puts stat[1]["id"]
			stat_total = PracticeStatTotal.create(
				value: stat[1]["total"],
				stat_list_id: stat[1]["id"],
				practice_id: @practice_id,
				team_id: @team_id,
				is_opponent: false
			)
			puts stat_total.errors.full_messages

		end
	end

	def create_opponent_stats()
		@opponent_stats.each do |stat|
			stat_total = PracticeStatTotal.create(
				value: stat[1]["total"],
				stat_list_id: stat[1]["id"],
				practice_id: @practice_id,
				team_id: @team_id,
				is_opponent: true
			)
			puts stat_total.errors.full_messages
		end
	end

	def create_player_stats()
		@player_stats.each do |stat|
			player_id = stat[1]["player_obj"]["id"]
			granule_arr = stat[1]["gran_stat_arr"]
			player_id = player_id.to_i

			cumulative_arr = stat[1]["cumulative_arr"]
			if granule_arr 
				granule_arr.each do |granule|
					metadata = granule[1]["metadata"]
					stat_list_id = granule[1]["stat"]
					stat_gran = PracticeStatGranule.create({
						metadata: metadata,
						member_id: player_id.to_i,
						practice_id: @practice_id,
						stat_list_id: stat_list_id.to_i,
					})
					puts stat_gran.errors.full_messages
				end
			end
			if cumulative_arr 
				counter = 0
				cumulative_arr.each do |cumulative_stat|
					stat_id = cumulative_stat[1]["id"]
					stat_total = cumulative_stat[1]["total"]
					stat_id = stat_id.to_i
					stat_total = stat_total.to_i
					cumulative_stat = PracticeStat.create({
						value: stat_total,
						practice_id: @practice_id,
						stat_list_id: stat_id,
						member_id: player_id,
					})

				end

=begin
				Stats::ShootingStatsService.new({
					field_goals: @field_goals,
					field_goal_att: @field_goals + @field_goal_misses,
					season_field_goals: @season_makes,
					season_field_goal_att: @season_makes + @season_misses,
					free_throw_makes: @free_throw_makes,
					free_throw_att: @free_throw_makes + @free_throw_misses,
					season_free_throw_makes: @season_free_throw_makes,
					season_free_throw_att: @season_free_throw_makes + @season_free_throw_misses,
					three_point_fg: @three_point_fg,
					three_point_att: @three_point_fg + @three_point_miss,
					season_three_point_fg: @season_three_point_makes,
					season_three_point_att: @season_three_point_makes + @season_three_point_misses,
					game_id: @game_id,
					member_id: player_id,
				}).call
=end
				
			end
		end
	end



end
