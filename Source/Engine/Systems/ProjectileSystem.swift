import SpriteKit
import PowerCore
import Fx
import Runes

final class ProjectileSystem {

	struct Unit {
		let entity: Entity
		let projectile: Box<Int>
		let sprite: Box<Int>
	}

	fileprivate let world: World
	private var units = [] as [Unit]
	private let disposable = CompositeDisposable()

	init(world: World, collisionsSystem: CollisionsSystem) {
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
				self.units.fastRemove(at: index)
			}
		}

		disposable += collisionsSystem.didBeginContact
			.observe(unown(self, type(of: self).processContact))
	}

	func update() {
//		let sprites = world.sprites
//		let projectiles = world.projectiles
//
//		for unit in units {
//			let projectile = projectiles[unit.projectile]
//
//			if case .homingMissle = projectile.type {
//
//			}
//
//		}
	}
}

/// Projectile collisions
private extension ProjectileSystem {

	func processContact(_ contact: SKPhysicsContact) {
		if let entityA = contact.bodyA.node?.entity,
			let entityB = contact.bodyB.node?.entity,
			let projectile = getProjectile(entityA: entityA, entityB: entityB) {

			let projectileComponent = world.projectiles[projectile.index]
			world.entityManager.removeEntity(projectile.entity)

			let transform = Transform(point: contact.contactPoint, vector: contact.contactNormal)
			EffectsFabric.createShellExplosion(world: world, at: transform)

			if let hp = getHP(entityA: entityA, entityB: entityB) {
				world.hp[hp.index].currentHP -= Int(projectileComponent.damage)
				if world.hp[hp.index].currentHP < 0 {
					if let spriteIndex = world.sprites.indexOf(hp.entity) {
						let sprite = world.sprites[spriteIndex].sprite
						EffectsFabric.createVehilceExplosion(world: world, at: sprite.transform)
					}
					let dead = DeadComponent(killedBy: projectileComponent.source)
					world.dead.add(component: dead, to: hp.entity)
				}
			}


		}
	}

	private func getProjectile(entityA: Entity, entityB: Entity) -> (index: Int, entity: Entity)? {
		if let index = world.projectiles.indexOf(entityA) {
			return (index, entityA)
		} else if let index = world.projectiles.indexOf(entityB) {
			return (index, entityB)
		} else {
			return nil
		}
	}

	private func getHP(entityA: Entity, entityB: Entity) -> (index: Int, entity: Entity)? {
		if let index = world.hp.indexOf(entityB) {
			return (index, entityB)
		} else if let index = world.hp.indexOf(entityA) {
			return (index, entityA)
		} else {
			return nil
		}
	}
}
