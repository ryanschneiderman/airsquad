
class Stats::GameModeCallbackService

	def initialize(params)
		@team_id = params[:team_id]
		@curr_season_id = params[:curr_season_id]
		@bpm_sums = [0, 0]
		@all_bpms = []
		@offensive_efficiency = SeasonTeamAdvStat.where(stat_list_id: 30, team_id: @team_id, is_opponent: false, season_id: @curr_season_id).take.value
		@defensive_efficiency = SeasonTeamAdvStat.where(stat_list_id: 31, team_id: @team_id, is_opponent: false, season_id: @curr_season_id).take.value
		@team_rating = @offensive_efficiency - @defensive_efficiency
	end

	def call
		@players = Member.where(season_id: @curr_season_id, team_id: @team_id, is_player: true)
		update_advanced_player_stats
		adjust_bpm
		stat_rankings
	end


	private

	def update_advanced_player_stats
		@players.each do |player|
			@bpms = Stats::Advanced::Player::SeasonAdvancedStatsService.new({
				member_id: player.id,
				team_id: @team_id,
				season_id: @curr_season_id
			}).call
			@minutes = player.season_minutes / 60.0
			@team_minutes = TeamSeasonStat.where(team_id: @team_id, stat_list_id: 16, is_opponent: false, season_id: @curr_season_id).take.value / 60.0
			puts @bpms["obpm"] 
			if(@bpms["obpm"] && @bpms["obpm"] != nil)
				puts "*******************IN OBPM*****************"

				@bpm_sums[0] += @bpms["obpm"] * (@minutes / (@team_minutes / 5))
				@bpm_sums[1] += @bpms["bpm"] * (@minutes / (@team_minutes / 5))
				@all_bpms.push(@bpms)
			end	
		end
	end

	def adjust_bpm

		bpm_team_adjustment = (@team_rating * 1.2 - @bpm_sums[1])/5

		@all_bpms.each do |bpm|
			new_bpm = bpm["bpm"] + bpm_team_adjustment
			new_bpm = new_bpm * 100 
			new_bpm = new_bpm.round / 100.0


			#obpm_team_adjustment = (@team_rating * 1.2 - @bpm_sums[1])/5
			new_obpm = bpm["obpm"] + bpm_team_adjustment
			new_obpm = new_obpm * 100
			new_obpm = new_obpm.round / 100.0
			

			season_stat = SeasonAdvancedStat.where(stat_list_id: 42, member_id: bpm["member_id"], season_id: @curr_season_id).take
			if season_stat
				season_stat.value = bpm["bpm"]
				season_stat.constituent_stats = {
					"team_adjustment" => bpm_team_adjustment,
					"raw_bpm" => bpm["bpm"]
				}
				season_stat.save
			else
				SeasonAdvancedStat.create({
					stat_list_id: 42,
					member_id: bpm["member_id"],
					constituent_stats: {
						"team_adjustment" => bpm_team_adjustment,
						"raw_bpm" =>  bpm["bpm"]
					},
					value: bpm["bpm"],
					season_id: @curr_season_id
				})
			end


			season_stat = SeasonAdvancedStat.where(stat_list_id: 40, member_id: bpm["member_id"], season_id: @curr_season_id).take
			if season_stat
				season_stat.value = bpm["obpm"]
				season_stat.constituent_stats = {
					"team_adjustment" => bpm_team_adjustment,
					"raw_bpm" => bpm["obpm"]
				}
				season_stat.save
			else
				SeasonAdvancedStat.create({
					stat_list_id: 40,
					member_id: bpm["member_id"],
					constituent_stats: {
						"team_adjustment" => bpm_team_adjustment,
						"raw_bpm" =>  bpm["obpm"]
					},
					value: bpm["obpm"],
					season_id: @curr_season_id
				})
			end

			# season_stat = SeasonAdvancedStat.where(stat_list_id: 42, member_id: bpm["member_id"], season_id: @curr_season_id).take
			# season_stat.value = bpm["bpm"]
			# season_stat.constituent_stats = {
			# 	"team_adjustment" => bpm_team_adjustment,
			# 	"raw_bpm" => bpm["bpm"]
			# }
			# season_stat.save

			# season_stat = SeasonAdvancedStat.where(stat_list_id: 40, member_id: bpm["member_id"], season_id: @curr_season_id).take
			# season_stat.value = bpm["obpm"]
			# season_stat.constituent_stats = {
			# 	"team_adjustment" => bpm_team_adjustment,
			# 	"raw_bpm" => bpm["obpm"]
			# }
			# season_stat.save
		end
	end

	def stat_rankings
		Stats::StatRankingsService.new({
			team_id: @team_id,
			season_id: @curr_season_id
		}).call

		Stats::Lineups::LineupStatRankingService.new({
			team_id: @team_id,
			season_id: @curr_season_id
		}).call
	end

	
end
