module PlaysHelper
	def plays_partial_path
		if @team_id != nil
			'plays/index/team_plays_index'
		else
			'plays/index/user_plays_index'
		end	
	end

	def play_link_partial_path
		if @team_id != nil
			'plays/plays/team_play'
		else
			'plays/plays/user_play'
		end
	end	
end
