import SpriteKit

enum ProjectileFactory {

	@discardableResult
	static func createProjectile(_ world: World, at position: CGPoint, velocity: CGVector, angle: Angle, projectile: ProjectileComponent, team: Team?) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createProjectileSprite(entity, type: projectile.type)

		sprite.sprite.run(SoundsFactory.cannon)

		let physics = PhysicsComponent(
			node: sprite.sprite,
			position: position,
			momentum: velocity,
			rotation: angle,
			category: projectile.type == .torpedo ? (team == .blue ? .blueShip : .redShip) : .projectile,
			contacts: team == .blue ? .redShip : .blueShip
		)
		let lifetime = LifetimeComponent(lifetime: 128)

		world.sprites.add(component: sprite, to: entity)
		world.physics.add(component: physics, to: entity)
		world.projectiles.add(component: projectile, to: entity)
		world.lifetime.add(component: lifetime, to: entity)

		return entity
	}
}
