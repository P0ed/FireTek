import SpriteKit

struct PhysicsSystem {

	private let world: World

	init(world: World) {
		self.world = world
	}

	func update() {
		applyVehicleInputs()
	}

	private func applyVehicleInputs() {
		let vehicles = world.vehicles
		let inputs = world.vehicleInput
		let physics = world.physics

		vehicles.forEach { vehicle in
			let input = inputs[vehicle.input.value]
			let physics = physics[vehicle.physics.value]
			applyInput(input, to: physics)
		}
	}

	private func applyInput(input: VehicleInputComponent, to physics: PhysicsComponent) {

	}
}
