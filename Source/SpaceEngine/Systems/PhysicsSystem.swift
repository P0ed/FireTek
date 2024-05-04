import SpriteKit

struct PhysicsSystem {

	private let world: World

	init(world: World) {
		self.world = world
	}

	func update() {
		applyShipInputs()
	}

	private func applyShipInputs() {
		world.ships.forEach { ship in
			let input = world.vehicleInput[ship.input]
			let physics = world.physics[ship.physics]
			applyShipInput(input, to: physics, stats: world.shipStats[ship.stats])
		}
	}

	private func applyShipInput(_ input: VehicleInputComponent, to physics: PhysicsComponent, stats: ShipStats) {
		let direction = CGVector(dx: 0, dy: 1).rotate(physics.body.node!.zRotation)
		let k = (input.accelerate > 0 ? 1 : 0.4) as CGFloat
		physics.body.applyImpulse(direction * CGFloat(stats.speed) * CGFloat(input.accelerate) * 7 * k)

		physics.body.applyTorque(CGFloat(stats.speed) * CGFloat(input.turnHull) * -0.6)

		physics.body.velocity = physics.body.velocity * 0.99
		physics.body.angularVelocity = physics.body.angularVelocity * 0.8
	}
}
