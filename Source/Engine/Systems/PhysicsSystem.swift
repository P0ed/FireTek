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
			applyInput(input, to: physics, stats: vehicle.stats)
		}
	}

	private func applyInput(input: VehicleInputComponent, to physics: PhysicsComponent, stats: VehicleComponent.Stats) {
		let direction = CGVector(dx: 0, dy: 1).rotate(physics.body.node!.zRotation)
		physics.body.applyImpulse(direction * CGFloat(stats.speed) * CGFloat(input.accelerate) * 5)
//		physics.body.applyForce(direction * CGFloat(stats.speed) * CGFloat(input.accelerate) * 200)
		physics.body.applyTorque(CGFloat(stats.speed) * CGFloat(input.turnHull) * -0.6)
		physics.body.velocity = physics.body.velocity * 0.95
		physics.body.angularVelocity = physics.body.angularVelocity * 0.8
	}
}
