#create granule objects for each granule in granules (its an array)
## create player_stat objects for each player_stat in player_stats (its an array)
## save them both 
## redirect to game path

class SubmitGameModeService

	def initialize(params)
		@player_stats = params[:player_stats]
		@game_id = params[:game_id]
		@team_stats = params[:team_stats]
		@opponent_obj = params[:opponent_stats]
		@opponent_stats =  @opponent_obj["cumulative_arr"]


		@team_id = params[:team_id]
	end


	def call
		create_player_stats()
		create_team_stats()
	end

	private

	def create_team_stats()
		@team_stats.each do |stat|
			puts stat[1]["total"]
			puts stat[1]["id"]

			stat_total = StatTotal.create(
				total: stat[1]["total"],
				stat_list_id: stat[1]["id"],
				game_id: @game_id,
				team_id: @team_id,
				is_opponent: false
			)
			if stat_total.save 
				puts "yay team stats saved"
			else 
				puts stat_total.save!
			end

		end
		@opponent_stats.each do |stat|
			stat_total = StatTotal.create(
				total: stat[1]["total"],
				stat_list_id: stat[1]["id"],
				game_id: @game_id,
				team_id: @team_id,
				is_opponent: true
			)
			if stat_total.save 
				puts "yay oppoenents saved"
			else 
				puts stat_total.save!
			end
		end
	end

	def create_player_stats()
		@player_stats.each do |stat|
			player_id = stat[1]["player_obj"]["id"]
			granule_arr = stat[1]["gran_stat_arr"]

			cumulative_arr = stat[1]["cumulative_arr"]
			if granule_arr 
				granule_arr.each do |granule|
					metadata = granule[1]["metadata"]
					puts metadata
					stat_list_id = granule[1]["stat_list_id"]
					stat_gran = StatGranule.create(
						metadata: metadata,
						member_id: player_id.to_i,
						game_id: @game_id.to_i,
						stat_list_id: stat_list_id.to_i,
					)
					if stat_gran.save
						puts "saved!!!"
					else
						puts stat_gran.save!
					end
				end
			end
			if cumulative_arr 
				cumulative_arr.each do |cumulative_stat|
				stat_id = cumulative_stat[1]["id"]
				stat_total = cumulative_stat[1]["total"]
				cumulative_stat = Stat.create(
					value: stat_total,
					game_id: @game_id,
					stat_list_id: stat_id,
					member_id: player_id,
				)
				end
			end
		end
	end


end