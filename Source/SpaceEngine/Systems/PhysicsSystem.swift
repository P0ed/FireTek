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

	private func apply(input: Input, ship: inout Ship, physics: inout Physics) {
		if input.impulse, ship.reactor.drain(ship.engine.impulse / 2) {
			physics.momentum += physics.rotation.vector * CGFloat(ship.engine.impulse) / 1024

			if ship.engine.driving & 0xF == 0 { physics.node.run(.play(.impulse)) }
			ship.engine.driving &+= 1
		} else if input.warp, ship.reactor.drain(ship.engine.warp / 2) {
			let mul = CGFloat(min(32, ship.engine.driving)) / 128
			physics.position += physics.rotation.vector * CGFloat(ship.engine.warp) * mul
			physics.momentum = physics.momentum * 0.97

			if ship.engine.driving & 0x1F == 0 { physics.node.run(.play(.warp)) }
			ship.engine.driving &+= 1
		} else if ship.engine.driving != 0 {
			ship.engine.driving = 0
		}

		if input.dpad.left {
			physics.rotation += CGFloat(ship.engine.impulse) / CGFloat(input.impulse ? 900 : 1600)
		} else if input.dpad.right {
			physics.rotation -= CGFloat(ship.engine.impulse) / CGFloat(input.impulse ? 900 : 1600)
		}
	}

	private func apply(physics: inout Physics) {
		if !physics.category.contains(.projectile), physics.momentum.length > .vMax {
			physics.momentum = physics.momentum.normalized * .vMax
		}
		physics.position += physics.momentum
	}

	private func chargeBanks(ship: inout Ship) {
		ship.reactor.charge()
		ship.primary.capacitor.charge(from: &ship.reactor)
		ship.secondary.capacitor.charge(from: &ship.reactor)
		ship.shield.charge(from: &ship.reactor)
	}
}

extension CGFloat {
	static var vMax: CGFloat { 2.2 }
}
