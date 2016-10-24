import PowerCore
import Fx

final class ProjectileSystem {

	struct Projectile {
		let entity: Entity
		let sprite: Closure<SpriteComponent?>
	}

	private let world: World
	private var projectiles = [] as [Projectile]
	private let disposable = CompositeDisposable()

	init(world: World) {
		self.world = world

		disposable += world.projectiles.newComponents.observe { [unowned self] index in
			let entity = world.projectiles.entityAt(index)
			let sprite = world.sprites.weakClosure(entity)
			let projectile = Projectile(entity: entity, sprite: sprite)
			self.projectiles.append(projectile)
		}

		disposable += world.projectiles.removedComponents.observe { entity, _ in

		}
	}
}
