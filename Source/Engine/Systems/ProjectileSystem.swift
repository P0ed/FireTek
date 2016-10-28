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

/// Projectile collisions
private extension ProjectileSystem {

	func processContact(_ contact: SKPhysicsContact) {
		if let entityA = contact.bodyA.node?.entity,
			let entityB = contact.bodyB.node?.entity,
			let indexes = indexesOf(entityA: entityA, entityB: entityB) {

			let projectile = world.projectiles[indexes.projectile]
			let projectileEntity = world.projectiles.entityAt(indexes.projectile)
			world.entityManager.removeEntity(projectileEntity)

			world.hp[indexes.hp].currentHP -= Int(projectile.damage)
			if world.hp[indexes.hp].currentHP < 0 {
				let hpEntity = world.hp.entityAt(indexes.hp)
				world.entityManager.removeEntity(hpEntity)
			}
		}
	}

	private func indexesOf(entityA: Entity, entityB: Entity) -> (hp: Int, projectile: Int)? {
		let hp = world.hp
		let projectiles = world.projectiles

		if let hpIndex = hp.indexOf(entityA), let projectileIndex = projectiles.indexOf(entityB) {
			return (hp: hpIndex, projectile: projectileIndex)
		}
		else if let hpIndex = hp.indexOf(entityB), let projectileIndex = projectiles.indexOf(entityA) {
			return (hp: hpIndex, projectile: projectileIndex)
		}
		else {
			return nil
		}
	}
}
