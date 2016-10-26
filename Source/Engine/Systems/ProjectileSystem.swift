import PowerCore
import Fx
import Runes

final class ProjectileSystem {

	struct Unit {
		let entity: Entity
		let projectile: Box<Int>
		let sprite: Box<Int>
	}

	private let world: World
	private var units = [] as [Unit]
	private let disposable = CompositeDisposable()

	init(world: World) {
		self.world = world

		disposable += world.projectiles.newComponents.observe { [unowned self] index in
			let projectile = world.projectiles.sharedIndexAt(index)
			let entity = world.projectiles.entityAt(index)

			if let spriteIndex = world.sprites.indexOf(entity) {
				let sprite = world.sprites.sharedIndexAt(spriteIndex)
				let projectile = Unit(entity: entity, projectile: projectile, sprite: sprite)
				self.units.append(projectile)
			}
		}

		disposable += world.projectiles.removedComponents.observe { [unowned self] entity, _ in
			if let index = self.units.index(where: { $0.entity == entity }) {
				self.units.remove(at: index)
			}
		}
	}

	func update() {
//		let sprites = world.sprites
		let projectiles = world.projectiles

		updateLifetme(projectiles: projectiles)

		for unit in units {
			let projectile = projectiles[unit.projectile]

			if case .homingMissle = projectile.type {

			}

		}
	}

	private func updateLifetme(projectiles: Store<ProjectileComponent>) {
		for index in projectiles.indices {
			projectiles[index].lifetime -= 1
		}

		projectiles.removeEntities { _, component in
			component.lifetime <= 0
		}
	}
}
