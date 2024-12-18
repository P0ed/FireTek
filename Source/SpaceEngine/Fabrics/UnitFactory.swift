import Fx
import SpriteKit

enum UnitFactory {

	@discardableResult
	static func createTank(world: World, position: Point, team: Team) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createShipSprite(entity, at: position)
		let hp = HPComponent(maxHP: 80, armor: 40)
		let physics = shipPhysics(sprite.sprite)

		let primary = WeaponComponent(
			type: .blaster,
			damage: 12,
			velocity: 340,
			cooldown: 1.2,
			perShotCooldown: 0.18,
			roundsPerShot: 3,
			maxAmmo: 60
		)

		let secondary = WeaponComponent(
			type: .blaster,
			damage: 36,
			velocity: 260,
			cooldown: 0.9,
			perShotCooldown: 0,
			roundsPerShot: 1,
			maxAmmo: 20
		)

		let stats = ShipStats(speed: 36)

		let ship = ShipComponent(
			sprite: world.sprites.sharedIndexAt § world.sprites.add(component: sprite, to: entity),
			physics: world.physics.sharedIndexAt § world.physics.add(component: physics, to: entity),
			hp: world.hp.sharedIndexAt § world.hp.add(component: hp, to: entity),
			input: world.vehicleInput.sharedIndexAt § world.vehicleInput.add(component: .empty, to: entity),
			stats: world.shipStats.sharedIndexAt § world.shipStats.add(component: stats, to: entity),
			primaryWpn: world.primaryWpn.sharedIndexAt § world.primaryWpn.add(component: primary, to: entity),
			secondaryWpn: world.secondaryWpn.sharedIndexAt § world.secondaryWpn.add(component: secondary, to: entity)
		)

		let mapItem = MapItem(
			type: team == .blue ? .ally : .enemy,
			node: sprite.sprite
		)

		world.ships.add(component: ship, to: entity)
		world.team.add(component: team, to: entity)
		world.targets.add(component: .none, to: entity)
		world.mapItems.add(component: mapItem, to: entity)

		world.loot.add(component: LootComponent(crystal: .orange, count: 3), to: entity)

		return entity
	}

	@discardableResult
	static func createAIPlayer(world: World, position: Point) -> Entity {
		let entity = createTank(world: world, position: position, team: .red)
		let vehicle = world.ships.sharedIndexAt § world.ships.indexOf(entity)!

		let ai = VehicleAIComponent(vehicle: vehicle, state: .hold(Point(x: 0, y: 0)), target: nil)
		world.vehicleAI.add(component: ai, to: entity)

		return entity
	}

	static func shipPhysics(_ sprite: SKSpriteNode) -> PhysicsComponent {
		let body = SKPhysicsBody(rectangleOf: sprite.size)
		body.mass = 40
		body.angularDamping = 1

		body.categoryBitMask = 0x1

		sprite.physicsBody = body
		return PhysicsComponent(body: body)
	}

	@discardableResult
	static func createBuilding(world: World, position: Point) -> Entity {
		let entity = world.entityManager.create()
		let sprite = SpriteFactory.createBuildingSprite(entity, at: position)
		let hp = HPComponent(maxHP: 40)

		let building = BuildingComponent(
			sprite: world.sprites.sharedIndexAt § world.sprites.add(component: sprite, to: entity),
			hp: world.hp.sharedIndexAt § world.hp.add(component: hp, to: entity)
		)
		world.buildings.add(component: building, to: entity)

		let physics = buildingPhysics(sprite.sprite)
		world.physics.add(component: physics, to: entity)
		world.loot.add(component: LootComponent(crystal: .blue, count: 1), to: entity)

		return entity
	}

	static func buildingPhysics(_ sprite: SKSpriteNode) -> PhysicsComponent {
		let body = SKPhysicsBody(rectangleOf: sprite.size)
		body.isDynamic = false

		body.categoryBitMask = 0x1

		sprite.physicsBody = body
		return PhysicsComponent(body: body)
	}

	@discardableResult
	static func addCrystal(world: World, crystal: Crystal, at position: CGPoint, moveBy offset: CGVector) -> Entity {
		let entity = world.entityManager.create()

		let sprite = SpriteFactory.createCrystal(entity: entity, at: position, crystal: crystal)

		let body = SKPhysicsBody(rectangleOf: sprite.sprite.size)
		body.categoryBitMask = 0x1 << 2
		body.collisionBitMask = 0x1
		body.contactTestBitMask = 0x1
		sprite.sprite.physicsBody = body

		sprite.sprite.run(.group([
			.repeatForever(.rotate(byAngle: 1, duration: 0.6)),
			.move(by: offset, duration: 0.6)
		]))

		world.sprites.add(component: sprite, to: entity)
		world.lifetime.add(component: LifetimeComponent(lifetime: 600), to: entity)
		world.crystals.add(component: crystal, to: entity)

		return entity
	}
}
