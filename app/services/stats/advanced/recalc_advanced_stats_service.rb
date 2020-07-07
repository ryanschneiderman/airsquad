##
## TODO: NEED TO RECALCULATE SHOOTING STATS!!!!!
##
##
class Stats::Advanced::RecalcAdvancedStatsService

	def initialize(params)
		@season_id = params[:season_id]
		@players = Member.where(season_id: @curr_season_id, team_id: @team_id, is_player: true)

		@member_id = nil
		
		@team_id = params[:team_id]
		@team = Team.find_by_id(@team_id)
		@bpm_sums = [0, 0]
		@season_bpm_sums = [0, 0]
		@all_bpms = []
		# @offensive_efficiency = SeasonTeamAdvStat.where(stat_list_id: 30, team_id: @team_id, is_opponent: false, season_id: @season_id).take.value
		# @defensive_efficiency = SeasonTeamAdvStat.where(stat_list_id: 31, team_id: @team_id, is_opponent: false, season_id: @season_id).take.value
		# @team_rating = @offensive_efficiency - @defensive_efficiency

	end

	def call
		update_advanced_team_stats
		update_advanced_player_stats
		adjust_bpm
	end

	private


	def update_advanced_team_stats
		## create team advanced stats 
		team_adv_stats = Stats::Advanced::Team::SeasonTeamAdvancedStatsService.new({
			team_id: @team_id,
			season_id: @season_id
		}).call

		@defensive_efficiency = team_adv_stats["defensive_efficiency"]
		@offensive_efficiency = team_adv_stats["offensive_efficiency"]

		if(@offensive_efficiency != nil && @defensive_efficiency != nil)
			@team_rating = @offensive_efficiency - @defensive_efficiency
		end
		puts "TEAM RATING"
		puts @team_rating

	end

	def update_advanced_player_stats
		@players.each do |player|
			bpms = Stats::Advanced::Player::SeasonAdvancedStatsService.new({
				member_id: player.id,
				team_id: @team_id.to_i,
				season_id: @season_id
			}).call
			@minutes = player.season_minutes / 60.0
			puts "PLAYER MINUTES in update"
			puts @minutes 
			@team_minutes = TeamSeasonStat.where(team_id: @team_id, stat_list_id: 16, is_opponent: false).take.value / 60.0 
			puts "TEAM MINUTES"
			puts @team_minutes
			if(bpms["obpm"] && bpms["obpm"].value != nil)
				@bpm_sums[0] += bpms["obpm"].value * (@minutes / (@team_minutes / 5))
				@bpm_sums[1] += bpms["bpm"].value * (@minutes / (@team_minutes / 5))
				@all_bpms.push(bpms)
			end	
		end
	end

	## TODO: MOVE TO DIFFERENT SERVICE -- come back to later
	def adjust_bpm
		bpm_team_adjustment = (@team_rating * 1.2 - @bpm_sums[1])/5
		@all_bpms.each do |bpm|
			new_bpm = bpm["bpm"].value + bpm_team_adjustment
			new_bpm = new_bpm * 100 
			new_bpm = new_bpm.round / 100.0


			#obpm_team_adjustment = (@team_rating * 1.2 - @bpm_sums[1])/5
			new_obpm = bpm["obpm"].value + bpm_team_adjustment
			new_obpm = new_obpm * 100
			new_obpm = new_obpm.round / 100.0
			

			season_stat = SeasonAdvancedStat.where(stat_list_id: 42, member_id: bpm["member_id"], season_id: @season_id).take
			season_stat.value = new_bpm
			season_stat.constituent_stats = {
				"team_adjustment" => bpm_team_adjustment,
				"raw_bpm" => bpm["bpm"].value
			}
			season_stat.save

			season_stat = SeasonAdvancedStat.where(stat_list_id: 40, member_id: bpm["member_id"], season_id: @season_id).take
			season_stat.value = new_obpm
			season_stat.constituent_stats = {
				"team_adjustment" => bpm_team_adjustment,
				"raw_bpm" => bpm["obpm"].value
			}
			season_stat.save
		end
	end

	
end
