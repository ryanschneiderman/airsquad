class TeamsController < ApplicationController
	
	def index
	end

	def show

		##InsertStatDescriptionsService.new().call()
		#Stats::FixFtRateService.new(team_id: params[:id]).call
		team = Team.find_by_id(params[:id])
		if(team.nil?)
			redirect_to root_path
		else
			@curr_member =  Assignment.joins(:role).joins(:member).select("roles.name as role_name, roles.id as role_id, members.*").where("members.user_id" => current_user.id, "members.team_id" => params[:id]).take
			
			@non_user_members = nil

			@date = Date.today
			@day_of_week = day_of_week(@date.wday)
			@month_string = month_string(@date.month).upcase
			@day_number = @date.day
			@year = @date.year
			@is_game = false
			@is_practice = false

			@team_id = params[:id]

			@schedule_event = ScheduleEvent.where(date: @date).take
			if @schedule_event
				@schedule_event_place = @schedule_event.place
				@schedule_event_time = @schedule_event.time
				@schedule_time_parsed = convert_time_readable(@schedule_event_time)
				@game = Game.where(schedule_event_id: @schedule_event.id).take
				if @game 
					@opponent = Opponent.find_by_id(@game.opponent_id)
					@opponent_name = @opponent.name
					@is_game = true
				end
				@practice = Practice.where(schedule_event_id: @schedule_event.id)
				@is_practice = true
			else
				puts "no event"
			end
			
			@post_objs = []
			@posts = Role.joins(members: [:posts, :assignments]).select("members.*,  posts.id as post_id, posts.created_at as post_created_at, posts.content as content, roles.id as role_id, roles.name as role_name").where("members.team_id" => params[:id], "roles.id" => [1,2]).uniq { |item| item.post_id }.sort_by{|post| post.post_id}
			
			@posts.each do |post|
				comments = Role.joins(members: [:comments, :assignments]).select("members.*, comments.id as comment_id, comments.post_id as post_id, comments.created_at as comment_created_at, comments.content as content, roles.id as role_id, roles.name as role_name").where("comments.post_id" => post.post_id, "roles.id" => [1,2]).uniq { |item| item.comment_id }.sort_by{|comment|  comment.comment_created_at}
				@post_objs.push({post: post, comments: comments})
			end
			@post_objs = @post_objs.reverse	
		end
	end

	def new
		@team = Team.new
		@new_member = Member.new


		@team_stat = TeamStat.new()
		## stats that user has to collect in order for the app to perform its basic functions
		@default_collectable = StatList.where(default_stat: true, collectable: true)
		gon.default_collectable = @default_collectable

		## stats the user may collect but arent required
		@non_default_collectable = StatList.where(default_stat: false, collectable: true)

		@default_basic = StatList.where(default_stat: true, rankable: true, advanced: false).sort_by{|stat| stat.id}

		## basic stats that the application automatically collects based on the default stats
		@default_application_basic = StatList.where(default_stat: true, collectable: false, advanced: false)
		gon.default_application_basic = @default_application_basic

		##advanced stats the application automatically collects based on the default stats
		@default_indiv_advanced = StatList.where(default_stat: true, advanced: true)
		gon.default_indiv_advanced = @default_indiv_advanced

		## should be nil
		@default_team_advanced = StatList.where(default_stat: true, advanced: true, team_stat: true)

		## advanced stats the application may collect depending on non default stats collected
		@non_default_indiv_advanced = StatList.where(advanced: true, team_stat: false, default_stat: false, hidden: false)

		## advanced stats the application may collect depending on non default stats collected
		@non_default_team_advanced = StatList.where(advanced: true, team_stat: true, default_stat: false)

		@advanced_stats = AdvStatDependenciesService.new({adv_stats: @non_default_indiv_advanced}).call
		gon.advanced_stats = @advanced_stats

		@team_advanced_stats = TeamAdvStatDependenciesService.new({adv_stats: @non_default_team_advanced}).call
		gon.team_advanced_stats = @team_advanced_stats

		## advanced team stats the application may collect depending on non default stats collected
		@team_advanced = StatList.where(advanced: true, team_stat: true)
	end

	def create
		team = Team.create({
			name: params[:team_name],
			num_periods: params[:period_type],
			period_length: params[:period_length],
			sport_id: 1,
			primary_color: params[:primary_color],
			secondary_color: params[:secondary_color],
		})


		season = Season.create({
			team_id: team.id,
			year1: Date.current.year
		})

		Teams::CreateTeamMembersService.new({
			members: params[:members],
			team_id: team.id,
			season_id: season.id
		}).call


		admin = Member.create({
			nickname: "Coach " + current_user.first_name,
			team_id: team.id,
			user_id: current_user.id,
			permissions: {"plays_view" => true, "plays_edit" => true, "schedule_view" => true, "schedule_edit" => true, "stats_view" => true, "stats_edit" => true, "settings_view" => true, "settings_edit" => true },
			is_admin: true,
			season_id: season.id
		})

		Assignment.create({
			member_id: admin.id,
			role_id: 2
		})

		Teams::TeamStatService.new({
			team_stats: params[:team_stats],
			team_id: team.id
		}).call

		redirect_to team_path(team.id)
	end	

	def join

		roles = params[:member_type]
		team_username = params[:username]
		team_password = params[:password]
		
		## TODO: UPDATE ROLES
		team_id = JoinTeamService.new({
			roles: roles,
			team_username: team_username,
			team_password: team_password,
			current_user: current_user,
			root_path: root_path,
		}).call

		redirect_path = root_path

		if team_id 
			redirect_path = team_path(team_id, joined_team: true)
		end


		## eventually redirect to a place depending on if JoinTeamService returns a value
		redirect_to redirect_path
	end

	def join_member
		id_to_join = params[:member_id]
		member = Member.find_by_id(id_to_join)
		member.user_id = current_user.id 
		member.save
	end

	private

	def team_params
		params.require(:team).permit(:name, :username, :password, :primary_color, :secondary_color)                  
	end

	def convert_time_readable(time)


		substring = time.strftime("%I:%M%p")
		return substring
=begin
		substring = time[0, time.index(' ')+1)]
		military_time = substring.[0,substring.index(' ')]
		length = military_time.length
		seconds_stripped = military_time[0,length - 3]
		military_hours = seconds_stripped[0,seconds_stripped.index(":")]
		minutes = seconds_stripped[seconds_stripped.index(":")+1)
		hours = military_hours % 12
		suffix = (military_hours > 12) ? " PM" : " AM"
		return hours + ":" + minutes + suffix
=end
	end

	def day_of_week(day_int)
		case day_int
		when 0
			return "Sunday"
		when 1
			return "Monday"
		when 2
			return "Tuesday"
		when 3
			return "Wednesday"
		when 4
			return "Thursday"
		when 5
			return "Friday"
		when 6
			return "Saturday"
		end
	end

	def month_string(month_int)
		case month_int
		when 1
			return "January"
		when 2
			return "February"
		when 3
			return "March"
		when 4
			return "April"
		when 5
			return "May"
		when 6
			return "June"
		when 7
			return "July"
		when 8
			return "August"
		when 9
			return "September"
		when 10
			return "October"
		when 11
			return "Novemeber"
		when 12
			return "December"
		end
	end

	def get_post_type_object(post)
		case post.post_type_type
		when "Play"
			play = Play.find_by_id(post.post_type_id)
			progressions = Progression.where(:play_id => play.id).sort_by{|e| e.index}
			return progressions
		when "Game"
			return Game.find_by_id(post.post_type_id)
		end
	end

end
