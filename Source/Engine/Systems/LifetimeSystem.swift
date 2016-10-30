import PowerCore
import SpriteKit

final class LifetimeSystem {

	let world: World

	init(world: World) {
		self.world = world
	}

	func update() {
		updateExplosions()
	}

	private func updateExplosions() {
		let lifetime = world.lifetime

		for index in lifetime.indices {
			lifetime[index].lifetime -= 1
		}

		lifetime.removeEntities { _, component in
			component.lifetime <= 0
		}
	}
}
