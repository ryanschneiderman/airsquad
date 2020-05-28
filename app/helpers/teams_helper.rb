module TeamsHelper
	def team_index_stat_content
		if @admin_status
			'teams/index/admin_content/upload_button'
		else
			'teams/index/non_admin_content/stats_content'
		end
	end

	def get_schedule_event
		if @is_game
			'teams/show/game_schedule_event'
		elsif @is_practice
			'teams/show/practice_schedule_event'
		else
			'teams/show/no_event'
		end
	end
end
