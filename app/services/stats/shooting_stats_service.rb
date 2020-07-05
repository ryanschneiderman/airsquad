class Stats::ShootingStatsService
	def initialize(params)
		@field_goals = params[:field_goals]
		@field_goal_att = params[:field_goal_att]
		@season_field_goals = params[:season_field_goals]
		@season_field_goal_att = params[:season_field_goal_att]
		@free_throw_makes = params[:free_throw_makes]
		@free_throw_att = params[:free_throw_att]
		@season_free_throw_makes = params[:season_free_throw_makes]
		@season_free_throw_att = params[:season_free_throw_att]
		@three_point_fg = params[:three_point_fg]
		@three_point_att = params[:three_point_att]
		@season_three_point_fg = params[:season_three_point_fg]
		@season_three_point_att = params[:season_three_point_att]
		@game_id = params[:game_id]
		@member_id = params[:member_id]
		@season_id = params[:season_id]
	end

	def call 
		fg_pct()
		season_fg_pct()
		ft_pct()
		season_ft_pct()
		three_point_pct()
		season_three_point_pct()
		three_point_att()
		season_three_point_att()
		field_goal_att()
		season_field_goal_att()
		free_throw_att()
		season_free_throw_att()
	end

	private

	def fg_pct()
		if (@field_goal_att) == 0 
			field_goal_pct = 0 
		else 
			field_goal_pct = 100 * @field_goals/@field_goal_att
		end

		Stat.create({
			value: field_goal_pct,
			game_id: @game_id,
			stat_list_id: 27,
			member_id: @member_id,
			season_id: @season_id
		})
	end

	def season_fg_pct()
		if (@season_field_goal_att) == 0 
			season_field_goal_pct = 0 
		else 
			season_field_goal_pct = 100 * @season_field_goals/@season_field_goal_att
		end

		season_total = SeasonStat.where(member_id: @member_id, stat_list_id: 27, season_id: @season_id).take
		if season_total 
			season_total.value = season_field_goal_pct
			season_total.save
		else 
			SeasonStat.create({
				value: season_field_goal_pct,
				stat_list_id: 27,
				member_id: @member_id,
				season_id: @season_id
			})
		end
	end

	def ft_pct()
		if @free_throw_att == 0 
			free_throw_pct = 0 
		else 
			free_throw_pct = 100* @free_throw_makes/@free_throw_att
		end

		Stat.create({
			value: free_throw_pct,
			stat_list_id: 29,
			member_id: @member_id,
			game_id: @game_id,
			season_id: @season_id
		})
	end

	def season_ft_pct()
		if @season_free_throw_att == 0 
			season_free_throw_pct = 0 
		else 
			season_free_throw_pct = 100 * @season_free_throw_makes/@season_free_throw_att
		end
		season_total = SeasonStat.where(member_id: @member_id, stat_list_id: 29, season_id: @season_id).take
		if season_total 
			season_total.value = season_free_throw_pct
			season_total.save
		else 
			SeasonStat.create({
				value: season_free_throw_pct,
				stat_list_id: 29,
				member_id: @member_id,
				season_id: @season_id
			})
		end
	end

	def three_point_pct()
		if @three_point_att == 0 
			three_point_pct = 0 
		else 
			three_point_pct = 100 * @three_point_fg/@three_point_att
		end
		## create stats for 3 point %
		Stat.create({
			value: three_point_pct,
			stat_list_id: 28,
			member_id: @member_id,
			game_id: @game_id,
			season_id: @season_id
		})
	end

	def season_three_point_pct()
		if @season_three_point_att == 0 
			season_three_point_pct = 0 
		else 
			season_three_point_pct = 100 * @season_three_point_fg/@season_three_point_att
		end
		season_total = SeasonStat.where(member_id: @member_id, stat_list_id: 28, season_id: @season_id).take
		if season_total 
			season_total.value = season_three_point_pct
			season_total.save
		else 
			SeasonStat.create({
				value: season_three_point_pct,
				stat_list_id: 28,
				member_id: @member_id,
				season_id: @season_id
			})
		end
	end

	def three_point_att()
		Stat.create({
			value: @three_point_att,
			stat_list_id: 49,
			member_id: @member_id,
			game_id: @game_id,
			season_id: @season_id
		})
	end
	def season_three_point_att()
		season_total = SeasonStat.where(member_id: @member_id, stat_list_id: 53, season_id: @season_id).take
		if season_total 
			season_total.value = @season_three_point_att
			season_total.save
		else 
			SeasonStat.create({
				value: @season_three_point_att,
				stat_list_id: 49,
				member_id: @member_id,
				season_id: @season_id
			})
		end
	end

	def field_goal_att()
		Stat.create({
			value: @field_goal_att,
			stat_list_id: 48,
			member_id: @member_id,
			game_id: @game_id,
			season_id: @season_id
		})
	end

	def season_field_goal_att()
		season_total = SeasonStat.where(member_id: @member_id, stat_list_id: 52, season_id: @season_id).take
		if season_total 
			season_total.value = @season_field_goal_att
			season_total.save
		else 
			SeasonStat.create({
				value: @season_field_goal_att,
				stat_list_id: 48,
				member_id: @member_id,
				season_id: @season_id
			})
		end
	end

	def free_throw_att()
		Stat.create({
			value: @free_throw_att,
			stat_list_id: 50,
			member_id: @member_id,
			game_id: @game_id,
			season_id: @season_id
		})
	end

	def season_free_throw_att()
		season_total = SeasonStat.where(member_id: @member_id, stat_list_id: 54, season_id: @season_id).take
		if season_total 
			season_total.value = @season_free_throw_att
			season_total.save
		else 
		SeasonStat.create({
			value: @season_free_throw_att,
			stat_list_id: 50,
			member_id: @member_id,
			season_id: @season_id
		})
		end
	end
end



		

		

		

		
		

		
		