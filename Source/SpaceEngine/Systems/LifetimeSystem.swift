import Fx

final class LifetimeSystem {

	let world: World

	init(world: World) {
		self.world = world
	}

	func update() {
		updateLifetime()
		removeDead()
	}

	private func updateLifetime() {
		let lifetime = world.lifetime

		for index in lifetime.indices {
			lifetime[index].lifetime -= 1
		}

		lifetime.removeEntities { e, component in
			let isExpired = component.lifetime == 0
			if isExpired, let p = world.projectiles.weakRefOf(e) {

				if p.value?.type == .torpedo, let ph = world.physics.weakRefOf(e)?.value {
					world.unitFactory.makeExplosion(
						at: ph.position,
						angle: ph.rotation - .pi,
						textures: .torpHitTextures
					)
				}
			}

			return isExpired
		}
	}

	private func removeDead() {
		world.dead.removeEntities(where: { _, _ in true })
	}
}
