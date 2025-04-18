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
		world.shipRefs.forEach { shipRef in
			let input: VehicleInputComponent = world.vehicleInput[shipRef.input]
			var ship = world.shipStats[shipRef.ship]
			apply(input: input, ship: &ship, to: &world.physics[shipRef.physics])
			chargeBanks(ship: &ship)
			world.shipStats[shipRef.ship] = ship
		}
	}

	private func apply(input: VehicleInputComponent, ship: inout Ship, to physics: inout PhysicsComponent) {
		if input.impulse, ship.reactor.drain(ship.engine.impulse / 4) {
			physics.momentum += physics.rotation.vector * CGFloat(ship.engine.impulse) / 1024

			if physics.driving & 0xF == 0 { physics.body.node?.run(SoundsFactory.impulse) }
			physics.driving &+= 1
			physics.warping = false
		} else if input.warp, ship.reactor.drain(ship.engine.warp / 2) {
			let mul = CGFloat(min(24, physics.driving)) / 48
			physics.position += physics.rotation.vector * CGFloat(ship.engine.warp) * mul
			physics.momentum = physics.momentum * 0.96

			if physics.driving & 0x1F == 0 { physics.body.node?.run(SoundsFactory.warp) }
			physics.driving &+= 1
			physics.warping = true
		} else if physics.driving != 0 {
			physics.driving = 0
			physics.warping = false
		}

		if input.dhat.left {
			physics.rotation.value &+= ship.engine.impulse * 24
		} else if input.dhat.right {
			physics.rotation.value &-= ship.engine.impulse * 24
		}

		physics.position += physics.momentum
		physics.body.node!.position = physics.position
		physics.body.node!.zRotation = physics.rotation.radians
		if physics.momentum.length > 3 {
			physics.momentum = physics.momentum.normalized() * 3
		}
	}

	private func chargeBanks(ship: inout Ship) {
		ship.reactor.charge()
		ship.shield.charge(from: &ship.reactor)
		ship.primary.capacitor.charge(from: &ship.reactor)
		ship.secondary.capacitor.charge(from: &ship.reactor)
	}
}
