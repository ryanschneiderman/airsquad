require 'RMagick'
##consider massive servicing
class ProgressionsController < ApplicationController
	def index
	end

	def new
		@play = Play.find_by_id(params[:play_id]) 
		@team_id = params[:team_id]
		@progression_index = params[:progression_index].to_i + 1
		@play_type = PlayType.find_by_id(@play.play_type_id)

		if @progression_index > 1
			prev_progression_raw = Progression.where(play_id: params[:play_id], index: @progression_index - 1)
			@prev_progression = prev_progression_raw.take
			@prev_json_diagram = @prev_progression.json_diagram
			@prev_canvas_width = @prev_progression.canvas_width
		end
		if @progression_index < @play.num_progressions
			progressions = Progression.where("play_id = ? and index >= ?", @play.id, @progression_index)
			progressions.each do |progression|
				progression.index = progression.index + 1
				progression.save
			end
		end
	end

	def create
		play = Play.find_by_id(params[:progression][:play_id])
		team_id = params[:progression][:team_id]
		play.num_progressions = play.num_progressions + 1
		play.save
		play_name = play.name
		member = Member.where(user_id: current_user.id, team_id: team_id).take

		progression = Progression.new(
			json_diagram: params[:progression][:json_diagram], 
			index: params[:progression][:index].to_i, 
			play_id: params[:play_id], 
			canvas_width: params[:progression][:canvas_width], 
			notes: params[:progression][:notes],
		)
		progression_str = play.name + params[:progression][:index] + ".png"
		param_data = params[:progression][:play_image]
		image_data = Base64.decode64(param_data['data:image/png;base64,'.length .. -1])
		image = MiniMagick::Image.read(image_data)
		image.format("png")

		progression.play_image.attach(io: StringIO.new(image.to_blob), filename: progression_str, content_type: "image/jpeg")
		progression.save

		notification = Notification.where("notif_type_id = ? AND created_at >= ? AND notif_kind = ?", play.id, Date.today - 1, 'added').take 
		if !notification.nil?
			notification.update(content: (notification.data["count"] + 1).to_s + " progressions added for " + play_name, data: {"count" => notification.data["count"] + 1})
			MemberNotif.where(notification_id: notification.id).each do |notif|
				if notif.member_id != member.id
					notif.update(viewed: false, read: false)
					notif.data["progression_ids"].append(progression.id)
					notif.save
				end
			end 
		else
			notif = Notification.create(
				content: "1 progression added for " + play_name,
				team_id: team_id,
				notif_type_type: "Play",
				notif_type_id: play.id,
				data: {"count" => 1},
				notif_kind: "added"
			)
			members = Member.where(team_id: team_id)
			members.each do |team_member|
				if team_member.id != member.id
					MemberNotif.create(
						member_id: team_member.id,
						notification_id: notif.id,
						viewed: false,
						read: false,
						data: {"progression_ids" => [progression.id]}
					)
				else
					MemberNotif.create(
						member_id: team_member.id,
						notification_id: notif.id,
						viewed: true,
						read: true,
						data: {"progression_ids" => []}
					)
				end
			end
		end
		

		

		redirect_to team_plays_path(team_id)
	end

	def create_next
		play = Play.find_by_id(params[:progression][:play_id])
		team_id = params[:progression][:team_id]
		play_name = play.name
		member = Member.where(user_id: current_user.id, team_id: team_id).take

		play.num_progressions = play.num_progressions + 1
		play.save
		progression = Progression.new(
			json_diagram: params[:progression][:json_diagram], 
			index: params[:progression][:index].to_i, 
			play_id: params[:play_id], 
			canvas_width: params[:progression][:canvas_width], 
			notes: params[:progression][:notes],
		)
		
		progression_str = play.name + params[:progression][:index] + ".png"
		param_data = params[:progression][:play_image]
		image_data = Base64.decode64(param_data['data:image/png;base64,'.length .. -1])
		image = MiniMagick::Image.read(image_data)
		image.format("png")

		progression.play_image.attach(io: StringIO.new(image.to_blob), filename: progression_str, content_type: "image/jpeg")
		progression.save
		

		notification = Notification.where("notif_type_id = ? AND notif_type_type = ? AND created_at >= ? AND notif_kind = ?", play.id, "Play", Date.today - 1, 'added').take 

		if !notification.nil? 
			MemberNotif.where(notification_id: notification.id).each do |notif|
				if notif.member_id != member.id
					notif.update(viewed: false, read: false)
					notif.data["progression_ids"].append(progression.id)
					notif.save
				end
			end
		else
			notif = Notification.create(
				content: "1 progression added for " + play_name,
				team_id: team_id,
				notif_type_type: "Play",
				notif_type_id: play.id,
				data: {"count" => 1},
				notif_kind: "added"
			)
			members = Member.where(team_id: team_id)
			members.each do |team_member|
				if team_member.id != member.id
					MemberNotif.create(
						member_id: team_member.id,
						notification_id: notif.id,
						viewed: false,
						read: false,
						data: {"progression_ids" => [progression.id]}
					)
				else
					MemberNotif.create(
						member_id: team_member.id,
						notification_id: notif.id,
						viewed: true,
						read: true,
						data: {"progression_ids" => []}
					)
				end
			end
		end

		



		redirect_to  new_team_play_progression_path(team_id: team_id, play_id: play.id, progression_index: params[:progression][:index].to_i)
	end

	def show
		@progression = Progression.find_by_id(params[:id])

		@progressions = Progression.where(play_id: params[:play_id]).order(:index);
		@play = Play.find_by_id(params[:play_id])
		@play_name = @play.name

	end

	def edit 
		@progression = Progression.find_by_id(params[:id])
		@progression_index = @progression.index
		@play = Play.find_by_id(params[:play_id])
		@team_id = params[:team_id]
	end

	def update
		json_diagram = params[:progression][:json_diagram]
		progression_id = params[:progression][:progression_id]
		play_id = params[:progression][:play_id]
		team_id = params[:progression][:team_id]
		play_name = params[:play_name]
		play = Play.find_by_id(play_id)
		member = Member.where(user_id: current_user.id, team_id: team_id).take

		notification = Notification.where("notif_type_id = ? AND created_at >= ? AND notif_kind = ?", play.id, Date.today - 1, 'edited').take 
		
		if !notification.nil? 
			notification.update( data: {"count" => notification.data["count"] + 1})
			MemberNotif.where(notification_id: notification.id).each do |notif|
				if notif.member_id != member.id
					notif.update(viewed: false, read: false)
					if !notif.data["progression_ids"].include? progression_id
						notif.data["progression_ids"].append(progression_id)
					end
				end
			end
		else
			notif = Notification.create(
				content: "Play: " + play_name + " edited",
				team_id: team_id,
				notif_type_type: "Play",
				notif_type_id: play.id,
				data: {"count" => 1},
				notif_kind: "edited"
			)
			members = Member.where(team_id: team_id)
			members.each do |team_member|
				if team_member.id != member.id
					MemberNotif.create(
						member_id: team_member.id,
						notification_id: notif.id,
						viewed: false,
						read: false,
						data: {"progression_ids" => [progression_id]}
					)
				else
					MemberNotif.create(
						member_id: team_member.id,
						notification_id: notif.id,
						viewed: true,
						read: true,
						data: {"progression_ids" => []}
					)
				end
			end
		end

		
		play.update(name: play_name)
		play.save
		progression = Progression.find(params[:progression][:progression_id])
		

		progression_str = play.name + progression.index.to_s + ".png"

		param_data = params[:progression][:play_image]
		image_data = Base64.decode64(param_data['data:image/png;base64,'.length .. -1])
		image = MiniMagick::Image.read(image_data)
		image.format("png")
		progression.play_image.purge

		progression.play_image.attach(io: StringIO.new(image.to_blob), filename: progression_str, content_type: "image/jpeg")

		progression.update(json_diagram: json_diagram, canvas_width: params[:progression][:canvas_width], notes: params[:progression][:notes])
		progression.save
		redirect_to edit_team_play_path(team_id, play_id)
	end

	def remove_progression_notification
		member_notif_array = params[:member_notif_array]
		if !member_notif_array.nil?
			member_notif_array.each do |notif|
				member_notif_id = notif[1]["member_notif_id"].to_i
				progression_id = notif[1]["progression_id"].to_i
				member_notif = MemberNotif.find_by_id(member_notif_id)
				member_notif.data["progression_ids"] = member_notif.data["progression_ids"].reject{|progr| progr.to_i == progression_id}
				member_notif.save
				if member_notif.data["progression_ids"].length == 0
					member_notif.update(viewed: true, read: true)
				end
			end
		end

	end

	## NEED TO UPDATE
	def destroy
		progression = Progression.find_by_id(params[:id])
		play = Play.find_by_id(params[:play_id])
		team_id = params[:team_id]
		play.num_progressions = play.num_progressions-1
		play.save

		progressions = Progression.where("index > ? AND play_id = ?", progression.index, progression.play_id).each  do |progression|
			progression.index = progression.index-1
			progression.save
		end
		progression.destroy
		redirect_to edit_team_play_path(team_id, play.id)
	end

	private
	def progression_params
		params.require(:progression).permit(:json_diagram, :index, :play_id)
	end	
end
