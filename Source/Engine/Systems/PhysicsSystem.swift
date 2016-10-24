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
		let stats = world.vehicleStats

		vehicles.forEach { vehicle in
			let input = inputs[vehicle.input]
			let physics = physics[vehicle.physics]
			applyInput(input, to: physics, stats: stats[vehicle.stats])
		}
	}

	private func applyInput(_ input: VehicleInputComponent, to physics: PhysicsComponent, stats: VehicleStats) {
		let direction = CGVector(dx: 0, dy: 1).rotate(physics.body.node!.zRotation)
		physics.body.applyImpulse(direction * CGFloat(stats.speed) * CGFloat(input.accelerate) * 7)
		physics.body.applyTorque(CGFloat(stats.speed) * CGFloat(input.turnHull) * -0.6)
		physics.body.velocity = physics.body.velocity * 0.92
		physics.body.angularVelocity = physics.body.angularVelocity * 0.8
	}
}
