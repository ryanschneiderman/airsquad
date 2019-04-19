module TeamsHelper
	def team_index_stat_content
		if @admin_status
			'teams/index/admin_content/upload_button'
		else
			'teams/index/non_admin_content/stats_content'
		end
	end
end
