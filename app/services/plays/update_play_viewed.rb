class Plays::UpdatePlayViewed
	def initialize(params)
		@member_id = params[:member_id]
		@play_id = params[:play_id]
	end

	def call()
		play_view = PlayView.where(member_id: @member_id, play_id: @play_id)
		if play_view.nil?
			PlayView.create(
				play_id: @play_id,
				member_id: @member_id,
				viewed: Time.now
			)
		else
			play_view.update(viewed: Time.now)
		end
	end
end