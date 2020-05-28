class Plays::UpdatePlayViewedService
	def initialize(params)
		@member_id = params[:member_id]
		@play_id = params[:play_id]
	end

	def call()
		play_view = PlayView.where(member_id: @member_id, play_id: @play_id).take
		if play_view
			play_view.update(viewed: Time.now)
			
		else
			PlayView.create(
				play_id: @play_id,
				member_id: @member_id,
				viewed: Time.now
			)
		end
	end
end