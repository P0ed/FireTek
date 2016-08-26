struct PhysicsSystem {

	private let world: World

	init(world: World) {
		self.world = world
	}

	func update() {
		applyVehicleInputs()
	}

	private func applyVehicleInputs() {
//		world.vehicles
	}
}
