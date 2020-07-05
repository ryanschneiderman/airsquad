module GamesHelper
	def games_modal_partial_path(schedule_edit)
		if schedule_edit
			render "games/index/schedule_modals"
		end
	end

	def show_games_partial_path(played)
		if played
			"games/show/game_played"
		else
			"games/show/game_preview"
		end
	end

	def game_preview_partial_path(permission)
		if(permission)
			"games/show/enter_game_mode"
		else
			"games/show/game_preview_partial"
		end
	end
end
