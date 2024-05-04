import SpriteKit

enum StarSystemFactory {

	static func createSystem(world: World, data: StarSystemData) {
		createStar(world: world, data: data.star)
		data.planets.forEach { createPlanet(world: world, data: $0) }
	}

	@discardableResult
	static func createStar(world: World, data: StarSystemData.Star) -> Entity {
		let entity = world.entityManager.create()
		let sprite = SpriteFactory.createStar(entity: entity, data: data)

		sprite.addChild(createField(radius: data.radius))
		sprite.physicsBody = createPhysics(radius: data.radius)

		let mapItem = MapItem(type: .star, node: sprite)

		world.sprites.add(component: SpriteComponent(sprite: sprite), to: entity)
		world.mapItems.add(component: mapItem, to: entity)

		return entity
	}

	@discardableResult
	static func createPlanet(world: World, data: StarSystemData.Planet) -> Entity {
		let entity = world.entityManager.create()
		let sprite = SpriteFactory.createPlanet(entity: entity, data: data)

		sprite.addChild(createField(radius: data.radius))
		sprite.physicsBody = createPhysics(radius: data.radius)

		let planet = PlanetComponent(
			sprite: sprite,
			orbit: data.orbit,
			velocity: data.velocity,
			position: data.position
		)

		let mapItem = MapItem(type: .planet, node: sprite)

		world.sprites.add(component: SpriteComponent(sprite: sprite), to: entity)
		world.planets.add(component: planet, to: entity)
		world.mapItems.add(component: mapItem, to: entity)

		return entity
	}

	private static func createPhysics(radius: Float) -> SKPhysicsBody {
		let physics = SKPhysicsBody(circleOfRadius: CGFloat(radius))
		physics.isDynamic = false
		return physics
	}

	private static func createField(radius: Float) -> SKFieldNode {
		let field = SKFieldNode.radialGravityField()
		field.categoryBitMask = 0x1
		field.region = SKRegion(radius: radius + 250)
		field.minimumRadius = radius
		field.strength = radius / 110
		field.falloff = 1.5

		return field
	}
}
