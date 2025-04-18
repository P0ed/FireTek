import SpriteKit

enum ProjectileFactory {

	@discardableResult
	static func createProjectile(_ world: World, at position: Transform, velocity: CGFloat, projectile: ProjectileComponent, team: Team?) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createProjectileSprite(entity, type: projectile.type)
		sprite.sprite.transform = position
		sprite.sprite.setScale(0.25)

		sprite.sprite.run(SoundsFactory.cannon)

		let physics = projectilePhysics(sprite.sprite, projectile.type, team)
		physics.body.velocity = CGVector(dx: 0, dy: velocity)
			.rotate(CGFloat(position.zRotation))

		let lifetime = LifetimeComponent(lifetime: 128)

		world.sprites.add(component: sprite, to: entity)
		world.physics.add(component: physics, to: entity)
		world.projectiles.add(component: projectile, to: entity)
		world.lifetime.add(component: lifetime, to: entity)

		return entity
	}

	static func projectilePhysics(_ sprite: SKSpriteNode, _ type: WeaponType, _ team: Team?) -> PhysicsComponent {
		let body = SKPhysicsBody(rectangleOf: CGSize(width: 4, height: 4))
		body.isDynamic = true

		body.category = type == .torpedo ? (team == .blue ? .blueShips : .redShips) : .projectile
		body.collision = team == .blue ? .redShips : .blueShips
		body.contactTest = team == .blue ? .redShips : .blueShips

		sprite.physicsBody = body
		return PhysicsComponent(body: body, position: sprite.position)
	}
}

struct Category: OptionSet {
	var rawValue: UInt32

	static var zero: Category { .init(rawValue: 0) }
	static var blueShips: Category { .init(rawValue: 1 << 0) }
	static var redShips: Category { .init(rawValue: 1 << 1) }
	static var projectile: Category { .init(rawValue: 1 << 2) }
	static var crystal: Category { .init(rawValue: 1 << 3) }
}

extension SKPhysicsBody {
	var category: Category {
		get { Category(rawValue: categoryBitMask) }
		set { categoryBitMask = newValue.rawValue }
	}
	var collision: Category {
		get { Category(rawValue: collisionBitMask) }
		set { collisionBitMask = newValue.rawValue }
	}
	var contactTest: Category {
		get { Category(rawValue: contactTestBitMask) }
		set { contactTestBitMask = newValue.rawValue }
	}
}
