import PowerCore
import SpriteKit

final class EffectsSystem {

	let world: World

	init(world: World) {
		self.world = world
	}

	func update() {
		updateExplosions()
	}

	private func updateExplosions() {
		let explosions = world.explosions

		for index in explosions.indices {
			explosions[index].lifetime -= 1
		}

		explosions.removeEntities { _, explosion in
			explosion.lifetime <= 0
		}
	}
}
