import SpriteKit

enum ProjectileFactory {

	@discardableResult
	static func createProjectile(_ world: World, at position: CGPoint, velocity: CGVector, angle: CGFloat, projectile: ProjectileComponent, team: Team?) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createProjectileSprite(entity, type: projectile.type)

		sprite.run(.play(.blaster))

		let physics = PhysicsComponent(
			node: sprite,
			position: position,
			momentum: velocity,
			rotation: angle,
			category: .projectile.union(projectile.type == .torpedo ? team?.category ?? [] : []),
			contacts: team?.opposite.category ?? [.blu, .red]
		)
		let lifetime = LifetimeComponent(lifetime: projectile.type == .torpedo ? 360 : 180)

		world.physics.add(component: physics, to: entity)
		world.projectiles.add(component: projectile, to: entity)
		world.lifetime.add(component: lifetime, to: entity)

		return entity
	}
}

extension Team {
	var opposite: Team { self == .blue ? .red : .blue }
	var category: Category { self == .blue ? .blu : .red }
}
