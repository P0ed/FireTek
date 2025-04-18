import SpriteKit

enum ProjectileFactory {

	@discardableResult
	static func createProjectile(_ world: World, at position: CGPoint, velocity: CGVector, angle: CGFloat, projectile: ProjectileComponent, team: Team?) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createProjectileSprite(entity, type: projectile.type)

		sprite.run(SoundsFactory.cannon)

		let physics = PhysicsComponent(
			node: sprite,
			position: position,
			momentum: velocity,
			rotation: angle,
			category: .projectile,
			contacts: (team == .blue ? Category.redShip : Category.blueShip)
				.union(projectile.type == .torpedo ? Category.projectile : Category.zero)
		)
		let lifetime = LifetimeComponent(lifetime: projectile.type == .torpedo ? 320 : 120)

		world.physics.add(component: physics, to: entity)
		world.projectiles.add(component: projectile, to: entity)
		world.lifetime.add(component: lifetime, to: entity)

		return entity
	}
}
