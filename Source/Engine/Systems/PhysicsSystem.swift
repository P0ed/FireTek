import SpriteKit

struct PhysicsSystem {

	private let world: World

	init(world: World) {
		self.world = world
	}

	func update() {
		applyVehicleInputs()
		applyShipInputs()
	}

	private func applyVehicleInputs() {
		world.vehicles.forEach { vehicle in
			let input = world.vehicleInput[vehicle.input]
			let physics = world.physics[vehicle.physics]
			applyVehicleInput(input, to: physics, stats: world.vehicleStats[vehicle.stats])
		}
	}

	private func applyVehicleInput(_ input: VehicleInputComponent, to physics: PhysicsComponent, stats: VehicleStats) {
		let direction = CGVector(dx: 0, dy: 1).rotate(physics.body.node!.zRotation)
		physics.body.applyImpulse(direction * CGFloat(stats.speed) * CGFloat(input.accelerate) * 7)
		physics.body.applyTorque(CGFloat(stats.speed) * CGFloat(input.turnHull) * -0.6)
		physics.body.velocity = physics.body.velocity * 0.92
		physics.body.angularVelocity = physics.body.angularVelocity * 0.8
	}

	private func applyShipInputs() {
		world.ships.forEach { ship in
			let input = world.shipInput[ship.input]
			let physics = world.physics[ship.physics]
			applyShipInput(input, to: physics, stats: world.vehicleStats[ship.stats])
		}
	}

	private func applyShipInput(_ input: ShipInputComponent, to physics: PhysicsComponent, stats: VehicleStats) {
		let direction = CGVector(dx: 0, dy: 1).rotate(physics.body.node!.zRotation)
		let k = (input.accelerate > 0 ? 1 : 0.4) as CGFloat
		physics.body.applyImpulse(direction * CGFloat(stats.speed) * CGFloat(input.accelerate) * 7 * k)

		physics.body.applyTorque(CGFloat(stats.speed) * CGFloat(input.turnHull) * -0.6)

		let strafe = CGVector(dx: CGFloat(input.strafe), dy: 0).rotate(physics.body.node!.zRotation)
		physics.body.applyImpulse(strafe * CGFloat(stats.speed) * 4)

		physics.body.velocity = physics.body.velocity * 0.99
		physics.body.angularVelocity = physics.body.angularVelocity * 0.8
	}
}
