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
			let input: VehicleInputComponent = world.vehicleInput[ship.input]
			var stats = world.shipStats[ship.stats]
			apply(input: input, stats: &stats, to: &world.physics[ship.physics])
			chargeBanks(stats: &stats)
			world.shipStats[ship.stats] = stats
		}
	}

	private func apply(input: VehicleInputComponent, stats: inout ShipStats, to physics: inout PhysicsComponent) {
		if input.impulse, stats.reactor.drain(stats.engine.impulse / 4) {
			physics.momentum += physics.rotation.vector * CGFloat(stats.engine.impulse) / 1024

			if physics.driving & 0xF == 0 { physics.body.node?.run(SoundsFactory.impulse) }
			physics.driving &+= 1
			physics.warping = false
		} else if input.warp, stats.reactor.drain(stats.engine.warp * 2) {
			let mul = CGFloat(min(24, physics.driving)) / 48
			physics.position += physics.rotation.vector * CGFloat(stats.engine.warp) * mul
			physics.momentum = physics.momentum * 0.96

			if physics.driving & 0x1F == 0 { physics.body.node?.run(SoundsFactory.warp) }
			physics.driving &+= 1
			physics.warping = true
		} else if physics.driving != 0 {
			physics.driving = 0
			physics.warping = false
		}

		if input.dhat.left {
			physics.rotation.value &+= stats.engine.impulse * 24
		} else if input.dhat.right {
			physics.rotation.value &-= stats.engine.impulse * 24
		}

		physics.position += physics.momentum
		physics.body.node!.position = physics.position
		physics.body.node!.zRotation = physics.rotation.radians
		if physics.momentum.length > 3 {
			physics.momentum = physics.momentum.normalized() * 3
		}
	}

	private func chargeBanks(stats: inout ShipStats) {
		stats.reactor.charge()
		stats.shield.charge(from: &stats.reactor)
	}
}
