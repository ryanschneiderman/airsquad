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

		redirect_to team_plays_path(team_id)
	end

	def create_next
		play = Play.find_by_id(params[:progression][:play_id])
		team_id = params[:progression][:team_id]
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
