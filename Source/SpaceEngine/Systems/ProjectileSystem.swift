import SpriteKit
import Fx

final class ProjectileSystem {

	struct Unit {
		let entity: Entity
		let projectile: ComponentIdx<ProjectileComponent>
		let sprite: ComponentIdx<SpriteComponent>
	}

	private let world: World
	private let damageSystem: DamageSystem

	private var units = [] as [Unit]
	private let disposable = CompositeDisposable()

	init(world: World, collisionsSystem: CollisionsSystem, damageSystem: DamageSystem) {
		self.world = world
		self.damageSystem = damageSystem

		disposable += world.projectiles.newComponents.observe { [unowned self] index in
			let projectile = world.projectiles.sharedIndexAt(index)
			let entity = world.projectiles.entityAt(index)

			if let spriteIndex = world.sprites.indexOf(entity) {
				let sprite = world.sprites.sharedIndexAt(spriteIndex)
				let projectile = Unit(entity: entity, projectile: projectile, sprite: sprite)
				self.units.append(projectile)
			}
		}

		disposable += world.projectiles.removedComponents
			.observe { [unowned self] entity, _ in
				if let index = self.units.firstIndex(where: { $0.entity == entity }) {
					self.units.fastRemove(at: index)
				}
			}

		disposable += collisionsSystem.didBeginContact
			.observe { [unowned self] in processContact($0) }
	}

	func update() {
		let sprites = world.sprites
		let projectiles = world.projectiles

		for unit in units {
			let projectile = projectiles[unit.projectile]

			if case .torpedo = projectile.type,
			   let target = projectile.target,
			   let idx = sprites.indexOf(target) {
				let t = sprites[idx].sprite.position
				let pSprite = sprites[unit.sprite].sprite
				let p = pSprite.position
				let dv = (t - p).vector.normalized() * 4
				pSprite.position = p + dv.point
			}
		}
	}
}

private extension ProjectileSystem {

	func processContact(_ contact: Contact) {
		guard let projectile = world.projectiles.first(contact.a, contact.b) else { return }

		let projectileComponent = projectile.value
		world.entityManager.removeEntity(projectile.entity)

		let transform = Transform(point: contact.point, vector: contact.normal)
		EffectsFactory.createShellExplosion(world: world, at: transform)

		if let shipRef = world.shipRefs.first(contact.a, contact.b) {
			damageSystem.damage(
				shipRef: shipRef,
				projectile: projectileComponent,
				point: contact.point,
				normal: contact.normal
			)
		}
	}
}
