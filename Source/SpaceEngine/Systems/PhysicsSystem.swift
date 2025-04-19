import SpriteKit

struct PhysicsSystem {
	private let world: World

	init(world: World) {
		self.world = world
	}

	func update() {
		for ref in world.shipRefs {
			apply(
				input: world.input[ref.input],
				ship: &world.ships[ref.ship],
				physics: &world.physics[ref.physics]
			)
		}
		for idx in world.physics.indices {
			apply(physics: &world.physics[idx])
		}
		for idx in world.ships.indices {
			chargeBanks(ship: &world.ships[idx])
		}
	}

	private func apply(input: InputComponent, ship: inout Ship, physics: inout PhysicsComponent) {
		if input.impulse, ship.reactor.drain(ship.engine.impulse / 4) {
			physics.momentum += physics.rotation.vector * CGFloat(ship.engine.impulse) / 1024

			ship.engine.driving &+= 1
		} else if input.warp, ship.reactor.drain(ship.engine.warp / 2) {
			let mul = CGFloat(min(24, ship.engine.driving)) / 48
			physics.position += physics.rotation.vector * CGFloat(ship.engine.warp) * mul
			physics.momentum = physics.momentum * 0.97

			if ship.engine.driving & 0x1F == 0 { physics.node.run(SoundsFactory.warp) }
			ship.engine.driving &+= 1
		} else if ship.engine.driving != 0 {
			ship.engine.driving = 0
		}

		if input.dhat.left {
			physics.rotation += CGFloat(ship.engine.impulse) / 1024
		} else if input.dhat.right {
			physics.rotation -= CGFloat(ship.engine.impulse) / 1024
		}
	}

	private func apply(physics: inout PhysicsComponent) {
		if physics.momentum.length > 3.3 {
			physics.momentum = physics.momentum.normalized() * 3.3
		}
		physics.position += physics.momentum
	}

	private func chargeBanks(ship: inout Ship) {
		ship.reactor.charge()
		ship.shield.charge(from: &ship.reactor)
		ship.primary.capacitor.charge(from: &ship.reactor)
		ship.secondary.capacitor.charge(from: &ship.reactor)
	}
}
