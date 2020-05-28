
class Plays::RecoverPlayService
	def initialize(params)
		@play_id = params[:play_id]
	end

	def call()
		play = Play.find_by_id(@play_id)
		play.update(deleted_flag: false)
		progression = Progression.where(play_id: play.id)
		progression_img = progression[0].play_image
		return {play_id: play.id, progression_img: progression_img, play_name: play.name}
	end
end