import SpriteKit
import Fx

final class ProjectileSystem {

	struct Unit {
		let entity: Entity
		let projectile: ComponentIdx<ProjectileComponent>
		let physics: ComponentIdx<Physics>
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

				let phy = physics[unit.physics]
				let tphy = physics[idx]
				let v = (tphy.position - phy.position).vector
				let m = (phy.momentum + v.normalized / 6).normalized * phy.momentum.length
				physics[unit.physics].momentum = m
				physics[unit.physics].rotation = m.angle - .pi / 2
			}
		}
	}
}

private extension ProjectileSystem {

	func processContact(_ contact: Contact) {
		guard let projectile = world.projectiles.first(contact.a, contact.b) else { return }

		let projectileComponent = projectile.value
		world.entityManager.removeEntity(projectile.entity)

		world.unitFactory.makeExplosion(
			at: contact.point,
			angle: contact.normal.angle,
			textures: projectileComponent.type == .blaster
				? .blasterHitTextures
				: .torpHitTextures
		)

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
