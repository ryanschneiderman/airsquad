class InsertRolesService
	def initialize()
	end

	def call()
		Role.create(
			name: "Player"
		)

		Role.create(
			name: "Admin"
		)

		Role.create(
			name: "Manager"
		)

		Role.create(
			name: "Owner"
		)

	end
end

