#create granule objects for each granule in granules (its an array)
## create player_stat objects for each player_stat in player_stats (its an array)
## save them both 
## redirect to game path

class SubmitGameModeService

	def initialize(params)
		@stats = params[:stats]
		@game_id = params[:game_id]
	end


	def call
		@stats.each do |stat|

			player_id = stat[1]["player_obj"]["id"]
			granule_arr = stat[1]["gran_stat_arr"]

			cumulative_arr = stat[1]["cumulative_arr"]
			if granule_arr 
				granule_arr.each do |granule|
					metadata = granule[1]["metadata"]
					puts "metadata"
					puts metadata
					stat_list_id = granule[1]["stat_list_id"]
					puts "stat_list_id"
					puts stat_list_id.class
					puts "game_id"
					puts @game_id.class
					puts "member_id"
					puts player_id.class
					stat_gran = StatGranule.create(
						metadata: metadata,
						member_id: player_id.to_i,
						game_id: @game_id.to_i,
						stat_list_id: stat_list_id.to_i,
					)
					puts "***************************************"
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