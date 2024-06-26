import SpriteKit

enum ProjectileFactory {

	@discardableResult
	static func createProjectile(_ world: World, at position: Transform, velocity: Float, projectile: ProjectileComponent) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createProjectileSprite(entity, type: projectile.type)
		sprite.sprite.transform = position

		sprite.sprite.run(SoundsFabric.cannon)

		let physics = projectilePhysics(sprite.sprite)
		physics.body.velocity = CGVector(dx: 0, dy: CGFloat(velocity))
			.rotate(CGFloat(position.zRotation))

		let lifetime = LifetimeComponent(lifetime: 90)

		world.sprites.add(component: sprite, to: entity)
		world.physics.add(component: physics, to: entity)
		world.projectiles.add(component: projectile, to: entity)
		world.lifetime.add(component: lifetime, to: entity)

		return entity
	}

	static func projectilePhysics(_ sprite: SKSpriteNode) -> PhysicsComponent {
		let body = SKPhysicsBody(rectangleOf: CGSize(width: 4, height: 4))
		body.isDynamic = true
		body.mass = 0.01

		body.categoryBitMask = 0x1 << 1
		let collideExcept: UInt32 = 0x1 << 1 | 0x1 << 2
		body.collisionBitMask = ~0 ^ collideExcept
		body.contactTestBitMask = 0x1

		sprite.physicsBody = body
		return PhysicsComponent(body: body)
	}
}
