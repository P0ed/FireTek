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
		if ship.engine.warping != 0 || input.warp {
			if input.warp, ship.reactor.drain(ship.engine.warp / 2) {
				let mul = CGFloat(min(32, ship.engine.warping)) / 128
				physics.position += physics.rotation.vector * CGFloat(ship.engine.warp) * mul
				physics.momentum = physics.momentum * 0.97
				if ship.engine.warping & 0x1F == 0 { physics.node.run(.play(.warp)) }
			}
			ship.engine.warping = input.warp
				? (ship.engine.warping < 0x7F ? ship.engine.warping + 1 : 0x40)
				: (ship.engine.warping + 1) & 0x1F
		}
		if ship.engine.driving != 0 || input.impulse, ship.engine.warping == 0 {
			if input.impulse, ship.reactor.drain(ship.engine.impulse / 2) {
				physics.momentum += physics.rotation.vector * CGFloat(ship.engine.impulse) / 1024
				if ship.engine.driving & 0x7 == 0 { physics.node.run(.play(.impulse)) }
			}
			ship.engine.driving = input.impulse
				? (ship.engine.driving < 0x7F ? ship.engine.driving + 1 : 0x40)
				: (ship.engine.driving + 1) & 0x7
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
		if ship.primary.capacitor.isCharged, ship.secondary.capacitor.isCharged {
			ship.shield.charge(from: &ship.reactor)
		}
	}
}

extension CGFloat {
	static var vMax: CGFloat { 2.2 }
}
