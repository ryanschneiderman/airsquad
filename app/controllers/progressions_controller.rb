
##consider massive servicing
class ProgressionsController < ApplicationController
	def index
	end

	def new
		@play = Play.find_by_id(params[:play_id]) 
		@progression_index = params[:progression_index].to_i + 1
		if @progression_index > 1
			prev_progression_raw = Progression.where(play_id: params[:play_id], index: @progression_index - 1)
			prev_progression = prev_progression_raw.take
			@prev_json_diagram = prev_progression.json_diagram
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
		@play = Play.find_by_id(params[:progression][:play_id])
		@play.num_progressions = @play.num_progressions + 1
		@play.save
		@progression = Progression.new(json_diagram: params[:progression][:json_diagram], index: params[:progression][:index].to_i, play_id: params[:play_id])
		@progression.save
		redirect_to play_path(@play.id)
	end

	def create_next
		@play = Play.find_by_id(params[:progression][:play_id])
		@play.num_progressions = @play.num_progressions + 1
		@play.save
		@progression = Progression.new(json_diagram: params[:progression][:json_diagram], index: params[:progression][:index], play_id: params[:play_id])
		@progression.save
		redirect_to  new_play_progression_path(@play.id)
	end

	def show
		@progression = Progression.find_by_id(params[:id])

		@progressions = Progression.where(play_id: params[:play_id]).order(:index);
		@play_name = Play.find_by_id(params[:play_id]).name

	end

	def edit 
		@progression = Progression.find_by_id(params[:id])
		@progression_index = @progression.index
		@play = Play.find_by_id(params[:play_id])
	end

	def update
		json_diagram = params[:progression][:json_diagram]
		progression_id = params[:progression][:progression_id]
		play_id = params[:progression][:play_id]
		@play = Play.find_by_id(play_id)
		@progression = Progression.find(params[:progression][:progression_id])
		@progression.update(json_diagram: json_diagram)
		@progression.save
		redirect_to play_path(play_id)
	end


	def destroy
		progression = Progression.find_by_id(params[:id])
		play = Play.find_by_id(progression.play_id)
		play.num_progressions = play.num_progressions-1
		play.save
		progressions = Progression.where(index: progression.index, play_id: progression.play_id).each  do |progression|
			progression.index = progression.index-1
			progression.save
		end
		Progression.find_by_id(params[:id]).destroy
		redirect_to play_path(play.id)
	end

	private
	def progression_params
		params.require(:progression).permit(:json_diagram, :index, :play_id)
	end	
end
