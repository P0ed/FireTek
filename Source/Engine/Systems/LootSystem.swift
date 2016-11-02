import SpriteKit
import PowerCore
import Fx

final class LootSystem {

	private let world: World
	private let collisionsSystem: CollisionsSystem
	private let disposable = CompositeDisposable()

	init(world: World, collisionsSystem: CollisionsSystem) {
		self.world = world
		self.collisionsSystem = collisionsSystem

		disposable += collisionsSystem.didBeginContact.observe { contact in

		}
	}

	func update() {
		spawnLoot()
	}

	private func spawnLoot() {
		for index in world.dead.indices {
			let entity = world.dead.entityAt(index)
			if let lootIndex = world.loot.indexOf(entity),
				let spriteIndex = world.sprites.indexOf(entity) {
				spawnLoot(
					loot: world.loot[lootIndex],
					at: world.sprites[spriteIndex].sprite.position
				)
			}
		}
	}

	private func spawnLoot(loot: LootComponent, at position: CGPoint) {

	}
}
