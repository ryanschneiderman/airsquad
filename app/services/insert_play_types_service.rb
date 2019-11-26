class InsertPlayTypesService
	def initialize()
		PlayType.delete_all
	end

	def call()
		PlayType.create(
			play_type: "Halfcourt"
		)

		PlayType.create(
			play_type: "Fullcourt"
		)
	end
end