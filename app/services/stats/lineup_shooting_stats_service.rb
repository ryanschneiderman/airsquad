class Stats::LineupShootingStatsService
	def initialize(params)
		@field_goals = params[:field_goals]
		@field_goal_att = params[:field_goal_att]
		@free_throw_makes = params[:free_throw_makes]
		@free_throw_att = params[:free_throw_att]
		@three_point_fg = params[:three_point_fg]
		@three_point_att = params[:three_point_att]
		@lineup_id = params[:lineup_id]
	end

	def call 
		fg_pct()
		ft_pct()
		three_point_pct()
		three_point_att()
		field_goal_att()
		free_throw_att()
	end

	private

	def fg_pct()
		if (@field_goal_att) == 0 
			field_goal_pct = 0 
		else 
			field_goal_pct = 100 * @field_goals/@field_goal_att
		end

		LineupStat.create({
			value: field_goal_pct,
			stat_list_id: 27,
			lineup_id: @lineup_id
		})
	end

	def ft_pct()
		if @free_throw_att == 0 
			free_throw_pct = 0 
		else 
			free_throw_pct = 100* @free_throw_makes/@free_throw_att
		end

		LineupStat.create({
			value: free_throw_pct,
			stat_list_id: 29,
			lineup_id: @lineup_id,
		})
	end


	def three_point_pct()
		if @three_point_att == 0 
			three_point_pct = 0 
		else 
			three_point_pct = 100 * @three_point_fg/@three_point_att
		end
		## create stats for 3 point %
		LineupStat.create({
			value: three_point_pct,
			stat_list_id: 28,
			lineup_id: @lineup_id,
		})
	end


	def three_point_att()
		LineupStat.create({
			value: @three_point_att,
			stat_list_id: 53,
			lineup_id: @lineup_id,
		})
	end

	def field_goal_att()
		LineupStat.create({
			value: @field_goal_att,
			stat_list_id: 52,
			lineup_id: @lineup_id,
		})
	end


	def free_throw_att()
		LineupStat.create({
			value: @free_throw_att,
			stat_list_id: 54,
			lineup_id: @lineup_id,
		})
	end

end



		

		

		

		
		

		
		