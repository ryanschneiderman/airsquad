=begin 

NOTE: final value is muliplied by 100 and then rounded and divided by 100.0 to round the value to 2 decimals 

=end

class Stats::Advanced::Player::BlockPctService

	def initialize(params)
		@blocks = params[:blocks]
		@team_minutes_played = params[:team_minutes]
		@minutes_played = params[:minutes]
		@opp_field_goal_att = params[:opp_field_goal_att]
		@opp_three_point_att = params[:opp_three_point_att]
	end

	def call()
		if @minutes_played * (@opp_field_goal_att - @opp_three_point_att) == 0
			return 0.0
		else 
			raw_blk = 100 * 100 * (@blocks * (@team_minutes_played / 5)) / (@minutes_played * (@opp_field_goal_att - @opp_three_point_att))
			raw_blk = raw_blk.round / 100.0
			return raw_blk
		end
	end

end