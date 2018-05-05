import PowerCore
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

		lifetime.removeEntities { _, component in
			component.lifetime == 0
		}
	}

	private func removeDead() {
		world.dead.removeEntities(where: { _, _ in true })
	}
}
