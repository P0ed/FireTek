import SpriteKit
import Fx

final class ProjectileSystem {

	struct Unit {
		let entity: Entity
		let projectile: ComponentIdx<ProjectileComponent>
		let physics: ComponentIdx<PhysicsComponent>
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

			if let phyIdx = world.physics.indexOf(entity) {
				let phy = world.physics.sharedIndexAt(phyIdx)
				let projectile = Unit(entity: entity, projectile: projectile, physics: phy)
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
		let physics = world.physics
		let projectiles = world.projectiles

		for unit in units {
			let projectile = projectiles[unit.projectile]

			if case .torpedo = projectile.type,
			   let target = projectile.target,
			   let idx = physics.indexOf(target) {
				let tpos = physics[idx].position
				let pos = physics[unit.physics].position
				let v = (tpos - pos).vector
				let dv = (v + physics[idx].momentum * min(1, v.length)).normalized() / 4
				physics[unit.physics].momentum += dv
			}
		}
	}
}

private extension ProjectileSystem {

	func processContact(_ contact: Contact) {
		guard let projectile = world.projectiles.first(contact.a, contact.b) else { return }

		let projectileComponent = projectile.value
		world.entityManager.removeEntity(projectile.entity)

		EffectsFactory.createShellExplosion(world: world, at: contact.point, angle: contact.normal.angle)

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
